LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity accel_rw is
	port 
	(
		CLK : in std_logic;
		reset_n : in std_logic;
		I2C_SCLK :  buffer std_logic;
		I2C_SDAT :  inout std_logic;
		G_SENSOR_CS_N :  buffer	std_logic;
		G_SENSOR_INT : in std_logic;
		read_signal : in std_logic;
		write_signal : in std_logic;
		CMD_IN : in std_logic_vector(7 downto 0);
		TX_IN : in std_logic_vector(7 downto 0);
		RX_out : out std_logic_vector(7 downto 0);
		busy_out : out std_logic
	);
end accel_rw ;

architecture accel_rw_arch of accel_rw  is

component spi_3_wire_master
  GENERIC(
    slaves    : INTEGER;  --number of spi slaves
    cmd_width : INTEGER;  --command bus width
    d_width   : INTEGER);
	port
	(
		clock   : IN     STD_LOGIC;                              --system clock
		reset_n : IN     STD_LOGIC;                              --asynchronous reset
		enable  : IN     STD_LOGIC;                              --initiate transaction
		cpol    : IN     STD_LOGIC;                              --spi clock polarity
		cpha    : IN     STD_LOGIC;                              --spi clock phase
		clk_div : IN     INTEGER;                                --system clock cycles per 1/2 period of sclk
		addr    : IN     INTEGER;                                --address of slave
		rw      : IN     STD_LOGIC;                              --'0' for read, '1' for write
		tx_cmd  : IN     STD_LOGIC_VECTOR(cmd_width-1 DOWNTO 0); --command to transmit
		tx_data : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);
		sclk    : BUFFER STD_LOGIC;
		ss_n    : BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);
		sdio    : INOUT  STD_LOGIC;
		busy    : OUT    STD_LOGIC;
		rx_data : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)
	);
end component;

component init_accel
	port 
	(
		CLK : in std_logic;
		reset_n : in std_logic;
		next_wr : in std_logic;
		busy : out std_logic
	);
end component;


TYPE   machine IS(INIT, IDLE, WR_ST, RD_ST, RX, TX);
signal state 			: machine;
signal rw_buffer	 	: std_logic;
signal cmd_buffer 		: std_logic_vector(7 downto 0);
--signal tx_data_buffer 	: std_logic_vector(15 downto 0);
--signal rx_data_buffer 	: std_logic_vector(15 downto 0);
signal busy 			: std_logic;
signal enable 			: std_logic;
signal cont 			: integer := 0;
signal int_acel 		: std_logic := '0';
signal SSN 				: std_logic_vector(0 downto 0);

signal next_wr_buffer 	: std_logic;
signal busy_buffer 		: std_logic;

signal cmd_to_spi 		: std_logic_vector(7 downto 0);
begin

	
	spi_3_wire_master_inst1 : spi_3_wire_master
	GENERIC map(
    slaves    => 1,  --number of spi slaves
    cmd_width => 8,  --command bus width
    d_width   => 8
	 )
	port map 
	(
		clock   => CLK,                              --system clock
		reset_n => reset_n,                          --asynchronous reset
		enable  => enable ,                          --initiate transaction
		cpol    => '1',                                 --spi clock polarity
		cpha    => '1',                                 --spi clock phase
		clk_div => 1,                                 --system clock cycles per 1/2 period of sclk
		addr    => 1,                                 --address of slave
		rw      => rw_buffer	,                    --'0' for read, '1' for write
		tx_cmd  => cmd_to_spi, 			     --command to transmit
		tx_data => TX_IN,			     --data to transmit
		sclk    => I2C_SCLK,				     --SPI SCLK
		ss_n(0) => G_SENSOR_CS_N,				     --Sensor SSN
		sdio    => I2C_SDAT,			             --SPI SDIO
		busy    => busy,			     --busy / data ready signal
		rx_data => RX_out			     --data received
	);
	
	cmd_to_spi <= (NOT(rw_buffer) & "0000000") OR ('0' & CMD_IN(6 downto 0));
	
	PROCESS(CLK, reset_n)
	BEGIN

		IF(reset_n = '0') THEN        --reset system
			state <= INIT;
	
		ELSIF(CLK'EVENT AND CLK = '0') THEN
			CASE state IS                 --state machine

        	WHEN INIT =>
				rw_buffer <= '0';
				--tx_data_buffer <= x"0000";
				enable <= '0';
				busy_out <= '0';
				state <= IDLE;

		  	WHEN  IDLE =>
				enable <= '0';
				busy_out <= '0';
				
				if (read_signal = '0') then
					state <= RD_ST;
				end if;
				if (write_signal = '0') then
					state <= WR_ST;
				end if;
				
		  	WHEN WR_ST => 
				rw_buffer <= '1';
				enable <= '1';
				busy_out <= '1';
				if (busy = '1') then 
					state <= TX;
					enable <= '0';
				end if;
				
		  	WHEN RD_ST => 
				rw_buffer <= '0';
				enable <= '1';
				busy_out <= '1';
				if (busy = '1') then 
					state <= RX;
					enable <= '0';
				end if;
		  
		  	WHEN RX =>
				busy_out <= '1';
				if (busy = '0') then
					state <= IDLE;
				end if;
		 
		  	WHEN TX =>
				busy_out <= '1';
				if (busy = '0') then
					state <= IDLE;
				end if;
      		END CASE;
		
   		END IF;
	END PROCESS; 
	
end accel_rw_arch;
