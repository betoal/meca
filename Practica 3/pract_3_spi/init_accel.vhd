LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity init_accel is
	port 
	(
		CLK : in std_logic;
		reset_n : in std_logic;
		next_wr : in std_logic;
		regs_to_wr : out std_logic;
		cmd_to_reg : out std_logic_vector(7 downto 0);
		val_to_reg : out std_logic_vector(7 downto 0)
	);
end init_accel;

architecture init_accel_arch of init_accel is

TYPE   machine IS(INIT, IDLE, WR_THRESH_ACT, WR_THRESH_INACT, WR_TIME_INACT, WR_ACT_INACT_CTL, 
			WR_THRESH_FF, WR_TIME_FF, WR_BW_RATE, WR_INT_ENABLE, WR_INT_MAP, WR_POWER_CONTROL, 
			WR_THRESH_TAP, WR_DUR, WR_TAP_AXES, WR_LATENT, WR_WINDOW);

SIGNAL state 			: machine := INIT;

signal rw_buffer	 	: std_logic;
signal cmd_buffer 		: std_logic_vector(7 downto 0) := X"00";
signal rx_buffer 		: std_logic_vector(7 downto 0) := X"00";

SIGNAL THRESH_TAP		: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"1D";
SIGNAL DUR 				: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"21";
SIGNAL LATENT			: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"22";
SIGNAL WINDOW			: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"23";
SIGNAL THRESH_ACT 		: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"24";
SIGNAL THRESH_INACT		: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"25";
SIGNAL TIME_INACT		: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"26";
SIGNAL ACT_INACT_CTL 	: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"27";
SIGNAL THRESH_FF		: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"28";
SIGNAL TIME_FF 			: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"29";
SIGNAL TAP_AXES			: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"2A";
SIGNAL BW_RATE 			: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"2C";
SIGNAL POWER_CONTROL 	: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"2D";
SIGNAL INT_ENABLE 		: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"2E";
SIGNAL INT_MAP 			: STD_LOGIC_VECTOR(7 DOWNTO 0) := X"2F";

signal busy_buffer 		: std_logic := '0';
signal done_init   		: std_logic := '0'; 

begin
regs_to_wr <= busy_buffer;
val_to_reg <= rx_buffer;
cmd_to_reg <= cmd_buffer;

	PROCESS(clk)
	BEGIN

		IF(reset_n = '0') THEN        --reset system
			state <= INIT;
	
		ELSIF(CLK'EVENT AND CLK = '0') THEN
			CASE state IS                 --state machine

        WHEN INIT =>
				state <= IDLE;
				busy_buffer <= '0';
				cmd_buffer <= x"00";
		  WHEN IDLE =>
				if (next_wr = '1' AND done_init = '0') then
					state <= WR_THRESH_ACT;
					busy_buffer <= '1';
				else
					busy_buffer <= '0';
				end if;
				cmd_buffer <= x"00";
				
		  WHEN WR_THRESH_ACT =>
				cmd_buffer <= THRESH_ACT;
				rx_buffer <= x"24";
				busy_buffer <= '1';

				if (next_wr = '1') then 
					state <= WR_THRESH_INACT ;
				end if;
				
		  
		  WHEN WR_THRESH_INACT =>
				cmd_buffer <= THRESH_INACT ;
				rx_buffer <= x"25";
				busy_buffer <= '1';
		  
				if (next_wr = '1') then 
					state <= WR_TIME_INACT ;
				end if;
		  
		  WHEN WR_TIME_INACT =>
			
				cmd_buffer <= TIME_INACT;
				rx_buffer <= x"26";
				busy_buffer <= '1';
		  
				if (next_wr = '1') then 
					state <= WR_ACT_INACT_CTL;
				end if;
		  
		  WHEN WR_ACT_INACT_CTL =>
				cmd_buffer <= ACT_INACT_CTL;
				rx_buffer <= x"27";
				busy_buffer <= '1';
		  
				if (next_wr = '1') then 
					state <= WR_THRESH_FF;
				end if;
		  
		  WHEN WR_THRESH_FF =>
				cmd_buffer <= THRESH_FF;
				rx_buffer <= x"28";
				busy_buffer <= '1';
		  
				if (next_wr = '1') then 
					state <= WR_TIME_FF;
				end if;
		  
		  WHEN WR_TIME_FF =>
			
				cmd_buffer <= TIME_FF;
				rx_buffer <= x"29";
				busy_buffer <= '1';
		  
				if (next_wr = '1') then 
					state <= WR_BW_RATE;
				end if;
		  
		  WHEN WR_BW_RATE =>
				cmd_buffer <= BW_RATE;
				rx_buffer <= x"2C";
				busy_buffer <= '1';
		  
				if (next_wr = '1') then 
					state <= WR_INT_ENABLE;
				end if;
		  
		  WHEN WR_INT_ENABLE => 
				cmd_buffer <= INT_ENABLE;
				rx_buffer <= x"2E";
				busy_buffer <= '1';
		  
				if (next_wr = '1') then 
					state <= WR_INT_MAP;
				end if;
		  
		  WHEN WR_INT_MAP =>
				cmd_buffer <= INT_MAP;
				rx_buffer <= x"2F";
				busy_buffer <= '1';
		  
				if (next_wr = '1') then 
					state <= WR_THRESH_TAP;
				end if;
				
		  WHEN WR_THRESH_TAP =>
				cmd_buffer <= THRESH_TAP;
				rx_buffer <= x"00";
				busy_buffer <= '1';
		  
				if (next_wr = '1') then 
					state <= WR_DUR;
				end if;
				
		  WHEN WR_DUR =>
				cmd_buffer <= DUR;
				rx_buffer <= x"00";
				busy_buffer <= '1';
		  
				if (next_wr = '1') then 
					state <= WR_TAP_AXES;
				end if;
				
		  WHEN WR_TAP_AXES => 
				cmd_buffer <= TAP_AXES;
				rx_buffer <= x"00";
				busy_buffer <= '1';
		  
				if (next_wr = '1') then 
					state <= WR_LATENT;
				end if;
			
		  WHEN WR_LATENT =>
				cmd_buffer <= LATENT;
				rx_buffer <= x"00";
				busy_buffer <= '1';
		  
				if (next_wr = '1') then 
					state <= WR_WINDOW;
				end if;
		 
		  WHEN WR_WINDOW => 
				cmd_buffer <= WINDOW;
				rx_buffer <= x"00";
				busy_buffer <= '1';
		  
				if (next_wr = '1') then 
					state <= WR_POWER_CONTROL;
				end if;
		  
		  WHEN WR_POWER_CONTROL =>
			
				cmd_buffer <= POWER_CONTROL;
				rx_buffer <= x"2D";
				busy_buffer <= '0';
		  
				if (next_wr = '1') then 
					state <= IDLE;
				end if;
				
      END CASE;
		
    END IF;
	END PROCESS; 
	
end init_accel_arch;