----------------------------------------------------------------------------------
-- Company: University of Queensland
-- Engineer: Peter Crosthwaite
-- 
-- Create Date:    13:38:55 02/25/2008 
-- Design Name: 
-- Module Name:    practop - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pracTop is
generic 
(
   SYSCLK_FREQUENCY_HZ : integer := 100000000;
   SCLK_FREQUENCY_HZ   : integer := 1000000;
   NUM_READS_AVG       : integer := 16;
   UPDATE_FREQUENCY_HZ : integer := 100
);
    Port ( ssegAnode : out  STD_LOGIC_VECTOR (7 downto 0);
           ssegCathode : out  STD_LOGIC_VECTOR (7 downto 0);
           slideSwitches : in  STD_LOGIC_VECTOR (15 downto 0);
           pushButtons : in  STD_LOGIC_VECTOR (4 downto 0);
           LEDs : out  STD_LOGIC_VECTOR (15 downto 0);
		   clk100mhz : in STD_LOGIC;
		   sine : out STD_LOGIC_VECTOR(7 DOWNTO 0);
		   cosine : out STD_LOGIC_VECTOR(7 downto 0);
		   rowIn : in STD_LOGIC_VECTOR(3 downto 0);
           columOut : out STD_LOGIC_VECTOR (3 downto 0);
           aclMISO : in STD_LOGIC;
           aclMOSI : out STD_LOGIC;
           aclSCK : out STD_LOGIC;
           aclSS : out STD_LOGIC;
           vgaRed : out STD_LOGIC_VECTOR(3 downto 0);
           vgaBlue: out STD_LOGIC_VECTOR(3 downto 0);
           vgaGreen: out STD_LOGIC_VECTOR(3 downto 0);
           Vsync : out STD_LOGIC;
           Hsync: out STD_LOGIC;
           PS2Clk : inout STD_LOGIC;
           PS2Data : inout STD_LOGIC
   );
end pracTop;

architecture Behavioral of pracTop is
    component ADXL362Ctrl
generic 
(
   SYSCLK_FREQUENCY_HZ : integer := 100000000;
   SCLK_FREQUENCY_HZ   : integer := 1000000;
   NUM_READS_AVG       : integer := 16;
   UPDATE_FREQUENCY_HZ : integer := 1000
);
port
(
 SYSCLK     : in STD_LOGIC; -- System Clock
 RESET      : in STD_LOGIC;
 
 -- Accelerometer data signals
 ACCEL_X    : out STD_LOGIC_VECTOR (11 downto 0);
 ACCEL_Y    : out STD_LOGIC_VECTOR (11 downto 0);
 ACCEL_Z    : out STD_LOGIC_VECTOR (11 downto 0);
 ACCEL_TMP  : out STD_LOGIC_VECTOR (11 downto 0);
 Data_Ready : out STD_LOGIC;
 
 --SPI Interface Signals
 SCLK       : out STD_LOGIC;
 MOSI       : out STD_LOGIC;
 MISO       : in STD_LOGIC;
 SS         : out STD_LOGIC

);
end component;

    component VGA_Interface port( 
        clk : in std_logic;  -- 25 Mhz clock
        row : out std_logic_vector(9 downto 0);
        column : out std_logic_vector(9 downto 0);
        Hsync : out std_logic;
        Vsync : out std_logic
    );end component;

  	component ssegDriver port (
		clk : in std_logic;
		rst : in std_logic;
		negative : in std_logic;
		negative2 : in std_logic;
		cathode_p : out std_logic_vector(7 downto 0);
		digit1_p : in std_logic_vector(3 downto 0);
		anode_p : out std_logic_vector(7 downto 0);
		digit2_p : in std_logic_vector(3 downto 0);
		digit3_p : in std_logic_vector(3 downto 0);
		digit4_p : in std_logic_vector(3 downto 0);
		digit5_p : in std_logic_vector(3 downto 0);
		digit6_p : in std_logic_vector(3 downto 0);
		digit7_p : in std_logic_vector(3 downto 0);
		digit8_p : in std_logic_vector(3 downto 0)
	); end component;
	
	component sin Port ( 
	    aclk : in STD_LOGIC;
        enableInput : in STD_LOGIC;
        enableOutput : out STD_LOGIC;
        down : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        up : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        sineOut : out STD_LOGIC_VECTOR(7 downto 0);
        clearFlag : in STD_LOGIC;
        Fflag : in STD_LOGIC;
        mode3 : in STD_LOGIC;
        mode4 : in STD_LOGIC;
        ACCEL_Xs : in STD_LOGIC_VECTOR (7 downto 0);
        MOUSE_X:  in STD_LOGIC_VECTOR (7 downto 0);
        modeChanged : in STD_LOGIC
    ); end component;
        
    component cosin Port ( 
        aclk : in STD_LOGIC;
        enableInput : in STD_LOGIC;
        enableOutput : out STD_LOGIC;
        left : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        right : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        cosineOut : out STD_LOGIC_VECTOR(7 DOWNTO 0);
        clearFlag : in STD_LOGIC;
        Fflag : in STD_LOGIC;
        modeChanged : in STD_LOGIC
    ); end component;
                
    component buttonHandler Port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        buttonIn : in STD_LOGIC;
        mode1 : in STD_LOGIC;
        display : out STD_LOGIC;
        result : out STD_LOGIC_VECTOR(7 DOWNTO 0)
    );end component;
    
    component showIncrement Port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        increment : in STD_LOGIC_VECTOR(7 downto 0);
        decrement : in STD_LOGIC_VECTOR(7 downto 0);
        firstDigit : out STD_LOGIC_VECTOR(3 DOWNTO 0);
        secondDigit : out STD_LOGIC_VECTOR(3 DOWNTO 0);
        thirdDigit : out STD_LOGIC_VECTOR(3 downto 0);
        negative : out STD_LOGIC
    );end component;
    
    component interfaceControl Port ( 
        clk : in STD_LOGIC;
        switches : in STD_LOGIC_VECTOR(2 downto 0);
        mode : out STD_LOGIC_VECTOR(4 downto 0);
        firstA : in STD_LOGIC_VECTOR(3 downto 0);
        secondA : in STD_LOGIC_VECTOR(3 downto 0);
        firstB : in STD_LOGIC_VECTOR(3 downto 0);
        secondB : in STD_LOGIC_VECTOR(3 downto 0);
        accX1 : in STD_LOGIC_VECTOR(3 downto 0);
        accX2 : in STD_LOGIC_VECTOR(3 downto 0); 
        accY1 : in STD_LOGIC_VECTOR(3 downto 0); 
        accY2 : in STD_LOGIC_VECTOR(3 downto 0); 
        x1 : in STD_LOGIC_VECTOR(3 downto 0);
        x2 : in STD_LOGIC_VECTOR(3 downto 0);
        y1 : in STD_LOGIC_VECTOR(3 downto 0);
        y2 : in STD_LOGIC_VECTOR(3 downto 0);
        outA1 : out STD_LOGIC_VECTOR(3 downto 0);
        outA2 : out STD_LOGIC_VECTOR(3 downto 0);
        outB1 : out STD_LOGIC_VECTOR(3 downto 0);
        outB2 : out STD_LOGIC_VECTOR(3 downto 0);
        fifthDigit : out STD_LOGIC_VECTOR(3 downto 0);
        sixthDigit : out STD_LOGIC_VECTOR(3 downto 0);
        seventhDigit : out STD_LOGIC_VECTOR(3 downto 0);
        eigthDigit : out STD_LOGIC_VECTOR(3 downto 0);
        modeChanged : out STD_LOGIC
    ); end component;
    
    component keyPad Port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        rows : in STD_LOGIC_VECTOR (3 downto 0);
        columns : out STD_LOGIC_VECTOR (3 downto 0);
        firstDigit : out STD_LOGIC_VECTOR (3 downto 0);
        secondDigit: out STD_LOGIC_VECTOR (3 downto 0);
        thirdDigit : out STD_LOGIC_VECTOR (3 downto 0);
        fourthDigit: out STD_LOGIC_VECTOR (3 downto 0);
        changeFlag : out STD_LOGIC;
        betweenModes : in STD_LOGIC;
        Fflag : out STD_LOGIC;
        mode2 : in STD_LOGIC
    );end component;
    
    component frequencyHandler Port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        number : integer;
        clockOut : out STD_LOGIC;
        clearFlag : in STD_LOGIC;
        Fflag : in STD_LOGIC;
        modeChanged : in STD_LOGIC);
    end component;
    

    component bcdToDecimal Port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        firstDigit : in STD_LOGIC_VECTOR(3 DOWNTO 0);
        secondDigit : in STD_LOGIC_VECTOR(3 downto 0);
        thirdDigit : in STD_LOGIC_VECTOR(3 DOWNTO 0);
        fourthDigit : in STD_LOGIC_VECTOR(3 downto 0);
        decimal1 : out integer;
        decimal : out integer);
    end component;
    
    component MouseCtl port(
       clk         : in std_logic;
       rst         : in std_logic;
       xpos        : out std_logic_vector(11 downto 0);
       ypos        : out std_logic_vector(11 downto 0);
       zpos        : out std_logic_vector(3 downto 0);
       left        : out std_logic;
       middle      : out std_logic;
       right       : out std_logic;
       new_event   : out std_logic;
       ps2_clk     : inout std_logic;
       ps2_data    : inout std_logic
    );
    end component;
    
    
    signal ENIN : std_logic :='1';
    signal ENOUT : std_logic;-- :='1';
    signal ENIN1 : std_logic :='1';
    signal ENOUT1 : std_logic;-- :='1';
    signal maybeCosine : std_logic_vector(7 downto 0);
    signal maybeSine : std_logic_vector(7 downto 0);
    
	signal masterReset : std_logic;
	signal clockScalers : std_logic_vector (26 downto 0);

	signal digit1 : std_logic_vector(3 downto 0);
	signal digit2 : std_logic_vector(3 downto 0);
	signal digit3 : std_logic_vector(3 downto 0);
	signal digit4 : std_logic_vector(3 downto 0);
	signal digit5 : std_logic_vector(3 downto 0);
	signal digit6 : std_logic_vector(3 downto 0);
	signal digit7 : std_logic_vector(3 downto 0);
	signal digit8 : std_logic_vector(3 downto 0);
	
    signal bDown : std_logic;
    signal bUp : std_logic;
    signal bRight : std_logic;
    signal bLeft : std_logic;
    signal negativeX : std_logic_vector(7 downto 0):="00000000";
    signal positiveX : std_logic_vector(7 downto 0):="00000000";
    signal negativeY : std_logic_vector(7 downto 0):="00000000";
    signal positiveY : std_logic_vector(7 downto 0):="00000000";
    signal modes: std_logic_vector(4 downto 0);
    
    --BCD testing
    signal one: std_logic_vector(3 downto 0);
    signal two: std_logic_vector(3 downto 0);
    signal three: std_logic_vector(3 downto 0);
    signal dp : std_logic:='1';
    
    signal four: std_logic_vector(3 downto 0);
    signal five: std_logic_vector(3 downto 0);
    signal six: std_logic_vector(3 downto 0);
    signal dp2 : std_logic:='1';
    
    signal a1: std_logic_vector(3 downto 0):="0001";
    signal a2: std_logic_vector(3 downto 0):="0000";
    signal b1: std_logic_vector(3 downto 0):="0001";
    signal b2: std_logic_vector(3 downto 0):="0000";
    
    signal key1: std_logic_vector(3 downto 0):="0000";
    signal key2: std_logic_vector(3 downto 0):="0001";
    signal key3: std_logic_vector(3 downto 0):="0000";
    signal key4: std_logic_vector(3 downto 0):="0001";
    
    signal frecuencyClock: integer:=1;
    signal frecuencyClock1: integer:=1;
    signal newClock : std_logic:='1';
    signal newClock1 : std_logic:='1';
    signal newSetUp : std_logic:='0';
    signal flagF : std_logic:='0';
    signal changingModes : std_logic:='0';
    
    signal onOff : std_logic:='1';
    signal bShow : std_logic;
    signal allModes : std_logic:='1';
    
    signal Data_Ready : std_logic;
    signal  ACCEL_X    : STD_LOGIC_VECTOR (11 downto 0);
    signal  ACCEL_Y    : STD_LOGIC_VECTOR (11 downto 0);
    signal  ACCEL_Z    : STD_LOGIC_VECTOR (11 downto 0);
    signal  ACCEL_TMP_OUT    : STD_LOGIC_VECTOR (11 downto 0);
    
    signal testRow : std_logic_vector(9 downto 0):="0000000000";
    signal testColumn : std_logic_vector(9 downto 0):="0000000000";
    
    --mouse signals
    signal ML : std_logic := '0';
    signal MM : std_logic := '0';
    signal MR : std_logic := '0';
    signal ME : std_logic := '0';
    signal MX : std_logic_vector(11 downto 0);
    signal MY : std_logic_vector(11 downto 0);
    signal MZ : std_logic_vector(3 downto 0);
    
    
begin

	masterReset <= slideSwitches(7);
	bShow <= pushButtons(4);
	bDown <= pushButtons(1);
	bUp <= pushButtons(2);
	bRight <= pushButtons(0);
	bLeft <= pushButtons(3);
	
	u1 : ssegDriver port map (
		clk => clockScalers(11),
		rst => masterReset,
		negative => dp,
		negative2 => dp2,
		cathode_p => ssegCathode,
		digit1_p => digit1,
		anode_p => ssegAnode,
		digit2_p => digit2,
		digit3_p => digit3,
		digit4_p => digit4,
		digit5_p => digit5,
		digit6_p => digit6,
		digit7_p => digit7,
		digit8_p => digit8
	);	
	
	u2: sin port map(
        aclk => newClock1,--clockScalers(2), 
        enableInput => ENIN,
        enableOutput => ENOUT,
        down => negativeX,
        up => positiveX,
        sineOut => maybeSine,
        clearFlag =>newSetUp,
        Fflag => flagF,
        mode3 => modes(3),
        mode4 => modes(4),
        ACCEL_Xs => ACCEL_X(11 downto 4),
        MOUSE_X => MX(7 downto 0),
        modeChanged => changingModes
    );
    
    u3: cosin port map(
        aclk => newClock,--clockScalers(2),--clk100mhz, 
        enableInput => ENIN1,
        enableOutput => ENOUT1,
        left => negativeY,
        right => positiveY,
        cosineOut => maybeCosine,
        clearFlag => newSetUp,
        Fflag => flagF,
        modeChanged => changingModes
    );
    
    u4: buttonHandler port map( --down
        clk => clockScalers(3), 
        rst => masterReset,
        buttonIn => bDown,
        mode1 => modes(1),
        result => negativeX
    );
    
    u5: buttonHandler port map( --up
        clk => clockScalers(3), 
        rst => masterReset,
        buttonIn => bUp,
        mode1 => modes(1),
        result => positiveX
    );
    
    u6: buttonHandler port map( --right
        clk => clockScalers(3), 
        rst => masterReset,
        buttonIn => bRight,
        mode1 => modes(1),
        result => positiveY
    );
    
    u7: buttonHandler port map( --left
        clk => clockScalers(3), 
        rst => masterReset,
        buttonIn => bLeft,
        mode1 => modes(1),
        result => negativeY
    );
    
    u8: interfaceControl Port map ( 
        clk => clockScalers(3),
        switches => slideSwitches(2 downto 0),
        mode => modes,
        firstA => key3,
        secondA => key4,
        firstB => key1 ,
        secondB => key2 ,
        accX1 => ACCEL_X(11 downto 8),
        accX2 => ACCEL_X(7 downto 4), 
        accY1 => ACCEL_Y(11 downto 8),
        accY2 => ACCEL_Y(7 downto 4), 
        x1 => four,--one,
        x2 => five,--two,
        y1 => one,--four,
        y2 => two,--five,
        outA1 => a1,
        outA2 => a2,
        outB1 => b1,
        outB2 => b2,
        fifthDigit => digit5,
        sixthDigit => digit6,
        seventhDigit => digit7,
        eigthDigit => digit8,
        modeChanged => changingModes
    );
    
    u9: showIncrement port map ( 
        clk => clockScalers(1),
        rst => masterReset,
        increment => positiveX,
        decrement => negativeX,
        firstDigit => one,
        secondDigit => two,
        thirdDigit => three,
        negative => dp
    );
    
    u10: showIncrement port map ( 
        clk => clockScalers(1),
        rst => masterReset,
        increment => positiveY,
        decrement => negativeY,
        firstDigit => four,
        secondDigit => five,
        thirdDigit => six,
        negative => dp2
    );
    
    u11: keyPad Port map ( 
        clk => clockScalers(10),
        rst => masterReset,
        rows => rowIn,
        columns => columOut,
        firstDigit => key1,
        secondDigit => key2,
        thirdDigit => key3,
        fourthDigit => key4,
        changeFlag => newSetUp,
        betweenModes => changingModes,
        Fflag => flagF,
        mode2 => modes(2)
    );
    
    u12: frequencyHandler Port map( 
        clk => clk100mhz,
        rst => masterReset,
        number => frecuencyClock,
        clockOut => newClock,
        clearFlag => newSetUp,
        Fflag => flagF,
        modeChanged => changingModes
    );
    
    u13: frequencyHandler Port map( 
        clk => clk100mhz,
        rst => masterReset,
        number => frecuencyClock1,
        clockOut => newClock1,
        clearFlag => newSetUp,
        Fflag => flagF,
        modeChanged => changingModes);
        
    u14: bcdToDecimal Port map( 
        clk => clk100mhz,
        rst => masterReset,
        firstDigit => a1,
        secondDigit => a2,
        thirdDigit => b1,
        fourthDigit => b2,
        decimal1 => frecuencyClock1,
        decimal => frecuencyClock 
    );
                   
    u15: buttonHandler port map( --show
        clk => clockScalers(3), 
        rst => masterReset,
        buttonIn => bShow,
        display => onOff,
        mode1 => allModes
    );
    
    u16: ADXL362Ctrl
        generic map
        (
           SYSCLK_FREQUENCY_HZ  => SYSCLK_FREQUENCY_HZ,
           SCLK_FREQUENCY_HZ    => SCLK_FREQUENCY_HZ,
           NUM_READS_AVG        => NUM_READS_AVG,   
           UPDATE_FREQUENCY_HZ  => UPDATE_FREQUENCY_HZ
        )
        port map
        (
         SYSCLK     => clockScalers(4),--clk100mhz,--clockScalers(11), 
         RESET      => masterReset, 
         
         -- Accelerometer data signals
         ACCEL_X    => ACCEL_X,
         ACCEL_Y    => ACCEL_Y, 
         ACCEL_Z    => ACCEL_Z,
         ACCEL_TMP  => ACCEL_TMP_OUT, 
         Data_Ready => Data_Ready, 
         
         --SPI Interface Signals
         SCLK       => aclSCK, 
         MOSI       => aclMOSI,
         MISO       => aclMISO, 
         SS         => aclSS
        );

    u17: VGA_Interface port map( 
        clk => clockScalers(1), -- 25 Mhz clock
        row => testRow,
        column => testColumn,
        Hsync => Hsync,
        Vsync => Vsync
    );
    
    u18 : mousectl Port map (
        clk => clockScalers(4),--clk100mhz,
        rst => masterReset,
        ps2_data => PS2Data,
        ps2_clk => PS2Clk,
        xpos => MX,
        ypos => MY,
        zpos => MZ,
        middle => MM,
        left => ML,
        right => MR,
        new_event => ME
        
    );
                   
	process (clk100mhz, masterReset) begin
		if (masterReset = '1') then
			clockScalers <= "000000000000000000000000000";
		elsif (clk100mhz'event and clk100mhz = '1')then
			clockScalers <= clockScalers + '1';
		end if;
	end process;
	
    with onOff select
        sine <= maybeSine when '1',
               "00000000" when others;
                        
    with onOff select
        cosine <= maybeCosine when '1',
                   "00000000" when others;
                   
    process(testrow, testcolumn)begin
        if(testrow <= 640 and testCOLUMN <= 700)then
            vgared <="1111";
            vgagreen <= "1111";
            vgablue <= "1111";
        end if;
        if(onOff = '1' and testrow >= maybeSine&'0' -6 and testrow <= maybeSine&'0' + 6  and testCOLUMN <= maybeCosine&'0'+6 and testCOLUMN >= maybeCosine&'0'-6)then
            vgared <="0000";
            vgagreen <= "0000";
            vgablue <= "1111";
        end if;
    end process;
    
    LEDs(0) <= onOff;
    digit1 <= '0' & slideSwitches(2 downto 0);
    
end Behavioral;

