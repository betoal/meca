LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity pract_3_spi is
	port 
	(
		CLK 		: in 	 std_logic;
		reset_n 	: in 	 std_logic;
		I2C_SCLK 	: buffer std_logic;
		I2C_SDAT 	: inout  std_logic;
		G_SENSOR_CS_N 	: buffer std_logic;
		G_SENSOR_INT  	: in 	 std_logic;
		btn_1 		: in 	 std_logic;
		LEDS  		: out    std_logic_vector( 7 downto 0);
		LEDS_OUT 	: out    std_logic_vector(15 downto 0);
		dip_sw 	 	: in     std_logic_vector( 3 downto 0)
	);
end pract_3_spi;

architecture pract_3_spi_arch of pract_3_spi is

component init_accel
	port 
	(
		CLK 		: in  std_logic;
		reset_n 	: in  std_logic;
		next_wr 	: in  std_logic;
		regs_to_wr 	: out std_logic;
		cmd_to_reg 	: out std_logic_vector(7 downto 0);
		val_to_reg 	: out std_logic_vector(7 downto 0)
	);
end component;

component accel_rw 
	port 
	(
		CLK 		: in     std_logic;
		reset_n 	: in     std_logic;
		I2C_SCLK 	: buffer std_logic;
		I2C_SDAT 	: inout  std_logic;
		G_SENSOR_CS_N 	: buffer std_logic;
		G_SENSOR_INT 	: in 	 std_logic;
		read_signal 	: in 	 std_logic;
		write_signal 	: in 	 std_logic;
		CMD_IN 		: in 	 std_logic_vector(7 downto 0);
		TX_IN 		: in 	 std_logic_vector(7 downto 0);
		RX_out 		: out 	 std_logic_vector(7 downto 0);
		busy_out 	: out 	 std_logic
	);
end component;

TYPE   machine IS(INIT, IDLE, WR_PARAMS_SEND, WRITING,  RD_PARAMS_SEND, READING);
SIGNAL state 		: machine;

signal cmd_buffer 	: std_logic_vector( 7 downto 0);
signal tx_data_buffer 	: std_logic_vector(7 downto 0);
signal rx_data_buffer 	: std_logic_vector(7 downto 0);

signal next_wr_buffer 	: std_logic := '0';
signal busy_buffer 	: std_logic := '0';
signal read_accel_n	: std_logic := '1';
signal write_accel_n 	: std_logic := '1';
signal init_done 	: std_logic := '0';
signal val_init_reg 	: std_logic_vector(7 downto 0) := x"00";

signal cmd_init_buffer 	: std_logic_vector(7 downto 0);
signal spi_busy 	: std_logic := '0';

signal leds_buffer 	: std_logic_vector( 7 downto 0) := x"00";
signal leds_out_buffer 	: std_logic_vector(15 downto 0) := x"0000";
signal reg_to_check 	: std_logic_vector( 7 downto 0) := x"00";

signal delay	 	: std_logic_vector(15 downto 0) := x"0000";

begin

	LEDS <= leds_buffer;
	LEDS_OUT <= leds_out_buffer;

	init_accel_inst1 : init_accel
	port map
	(
		CLK 		=> CLK,
		reset_n 	=> reset_n,
		next_wr 	=> next_wr_buffer,
		regs_to_wr	=> busy_buffer,
		cmd_to_reg	=> cmd_init_buffer,
		val_to_reg	=> val_init_reg
	);
	
	accel_rw_inst1 :accel_rw 
	port map
	(
		CLK 		=> CLK,
		reset_n 	=> reset_n,
		I2C_SCLK 	=> I2C_SCLK,
		I2C_SDAT 	=> I2C_SDAT,
		G_SENSOR_CS_N 	=> G_SENSOR_CS_N,
		G_SENSOR_INT 	=> G_SENSOR_INT,
		read_signal 	=> read_accel_n,
		write_signal 	=> write_accel_n,
		CMD_IN 		=> cmd_buffer,
		TX_IN 		=> tx_data_buffer,
		RX_out 		=> rx_data_buffer,
		busy_out 	=> spi_busy
	);
	
	reg_to_check <= 
		x"00" when dip_sw = "0000" else
		x"00" when dip_sw = "0001" else
		x"00" when dip_sw = "0010" else
		x"00" when dip_sw = "0011" else
		x"00" when dip_sw = "0100" else
		x"00" when dip_sw = "0101" else
		x"00" when dip_sw = "0110" else
		x"00" when dip_sw = "0111" else
		x"00" when dip_sw = "1000" else
		x"00" when dip_sw = "1001" else
		x"00" when dip_sw = "1010" else 
		x"00" when dip_sw = "1011" else
		x"00" when dip_sw = "1100" else
		x"00" when dip_sw = "1101" else
		x"00" when dip_sw = "1110" else
		x"00" when dip_sw = "1111" else	
		x"FF" ;
	
	
	PROCESS(CLK, reset_n)
	BEGIN
		
		IF(reset_n = '0') THEN        --reset system
			leds_buffer <= x"00";
			leds_out_buffer <= x"0000";
			state <= INIT;
	
		ELSIF(CLK'EVENT AND CLK = '0') THEN
			CASE state IS                 --state machine

				WHEN INIT =>
					leds_buffer <= x"00";
					--leds_out_buffer <= x"00";
					cmd_buffer <= x"00";
					tx_data_buffer <= x"00";
					write_accel_n <= '1';
					read_accel_n <= '1';
					init_done <= '0';
					next_wr_buffer <= '0';
					state <= IDLE;
					
				WHEN IDLE =>
					if ( init_done = '0' ) then
						state <= WR_PARAMS_SEND;
						next_wr_buffer <= '1';
					else
					
						if ( delay(15) = '1' ) then
							next_wr_buffer <= '0';
							tx_data_buffer <= x"00";
							delay <= x"0000";
							state <= RD_PARAMS_SEND;
						else 
							delay <= delay + 1;
						end if;
					
					end if;
				WHEN WR_PARAMS_SEND =>
					next_wr_buffer <= '0';
					cmd_buffer <= cmd_init_buffer;
					tx_data_buffer <= val_init_reg;
					write_accel_n <= '0';
					read_accel_n <= '1';

					if (spi_busy = '1') then
						state <= WRITING;
					end if;

				WHEN WRITING =>
					write_accel_n <= '1';
					read_accel_n <= '1';

					if ( busy_buffer = '0' ) then
						init_done <= '1';
					end if;
					
					if (spi_busy = '0') then
						state <= IDLE;
					end if;
					
				
				WHEN RD_PARAMS_SEND => 
					cmd_buffer <= reg_to_check;
					write_accel_n <= '1';
					read_accel_n <= '0';

					if (spi_busy = '1') then
						state <= READING;
					end if;
				
				WHEN READING =>
					write_accel_n <= '1';
					read_accel_n <= '1';
					
					if (spi_busy = '0') then
				--		leds_out_buffer <= rx_data_buffer;
						leds_buffer <= rx_data_buffer;
						state <= IDLE;
					end if;
				
      		END CASE;
		
    	END IF;
	END PROCESS; 
	
end pract_3_spi_arch;
