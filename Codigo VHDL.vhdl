----------------------------------------------------------------------------------
-- Proyecto N° 3 - Tecnicas Digitales I 
-- Control para el sistema de pesaje de cajas
-- 3R5 - 2021 - Grupo 2
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Proyecto is
    Port (  --  ENTRADAS: Sensores
            clk: in STD_LOGIC;
            CE : in  STD_LOGIC;
            EI : in  STD_LOGIC;
            ED : in  STD_LOGIC;
            PE : in  STD_LOGIC;
            PB : in  STD_LOGIC;
            PPS : in  STD_LOGIC;
            CPE : in  STD_LOGIC;
            CPS : in  STD_LOGIC;
            CDE : in  STD_LOGIC;
            B : in  STD_LOGIC;
			CB: in STD_LOGIC;
			CDS: in STD_LOGIC;
			  
            --  ENTRADAS: Pulsadores
            EM : in  STD_LOGIC;
            RE : in  STD_LOGIC;
            PA : in  STD_LOGIC;
            PP : in  STD_LOGIC;
            PM : in  STD_LOGIC;
            PIZQ : in  STD_LOGIC;
            PDER : in  STD_LOGIC;
            PEM : in  STD_LOGIC;
            PDM : in  STD_LOGIC;
            PTU : in  STD_LOGIC;
            PTD : in  STD_LOGIC;
			
            --  SALIDAS
            SMCE : out  STD_LOGIC;
            SMPTI : out  STD_LOGIC;
            SMPTD : out  STD_LOGIC;
            SMPCU : out  STD_LOGIC;
            SMPCD : out  STD_LOGIC;
            SMCD : out  STD_LOGIC;
            SMB : out  STD_LOGIC;
            LEM : out  STD_LOGIC);
end Proyecto;

architecture Behavioral of Proyecto is

    signal MANUAL: STD_LOGIC:= '0';
    signal PCORRECTO: STD_LOGIC;
	signal SEM: STD_LOGIC:= '0';
	signal MCE : STD_LOGIC:= '1';
    signal MPTI : STD_LOGIC:= '0';
    signal MPTD : STD_LOGIC:= '0';
    signal MPCU : STD_LOGIC:= '0';
    signal MPCD : STD_LOGIC:= '0';
    signal MCD : STD_LOGIC:= '0';
    signal MB : STD_LOGIC:= '1';
	signal CARGA: STD_LOGIC:= '0';
    signal PARO: STD_LOGIC:= '0';
	--signal test: STD_LOGIC:= '0';
	--signal test2: STD_LOGIC:= '1';
	 
	signal PMant: STD_LOGIC:= '0';
    signal PAant: STD_LOGIC:= '0';
    signal CEant: STD_LOGIC:= '0';
    signal PEant: STD_LOGIC:= '0';
    signal CDEant: STD_LOGIC:= '0';
	signal CDSant: STD_LOGIC:= '0';
    signal CPEant: STD_LOGIC:= '0';
    signal CBant: STD_LOGIC:= '0';
    signal PEMant: STD_LOGIC:= '0';
	signal PBant: STD_LOGIC:= '0';
    signal PDMant: STD_LOGIC:= '0';
	signal PPSant: STD_LOGIC:= '0';
	signal PPant: STD_LOGIC:= '0';

begin
    process (clk)
    begin
        if (clk'event and clk = '1') then
				
            -- Establecimiento de estado de emergencia
            if (RE = '1' and PE = '1') then 
				SEM <= '0';
				MCE <= '1';
                MPTI <= '0';
                MPTD <= '0';
                MPCU <= '0';
                MPCD <= '0';
                MCD <= '0';
                MB <= '1';
				MANUAL <= '0';
            else 
				if(EM = '1' or EI = '1' or ED = '1') then SEM <= '1';
				end if;
            end if;

            -- Establecimiento de estado manual
            if (PE = '1' and PA = '1' and PAant = '0') then 
                MANUAL <= '0';
                    
                -- Valores por defecto e inicial (automatico)
                MCE <= '1';
                MPTI <= '0';
                MPTD <= '0';
                MPCU <= '0';
                MPCD <= '0';
                MCD <= '0';
                MB <= '1';
			   
            else 
				 
                if (PE = '1' and PM = '1' and PMant = '0') then
                        MANUAL <= '1';

                        -- Valores por defecto e inicial (manual)
                        MCE <= '0'; 
                        MPTI <= '0';
                        MPTD <= '0';
                        MPCU <= '0';
                        MPCD <= '0';
                        MCD <= '0';
                        MB <= '1';
                end if;
            end if;
				
			-- Estado de paro
			if(PP = '1' and PPant = '0') then PARO <= not PARO;
			end if;

            if(SEM = '0') then
                if(MANUAL = '0') then
                    -- Funcionamiento automatico

                    -- MCE - Cinta 
                    if (CE = '1' and CEant = '0') then
                        if(CARGA = '0' and PE = '1') then CARGA <= '1';
                        else MCE <= '0';
                        end if;
                    end if;

                    if(PE = '1' and PEant = '0') then
                        if (CE = '1') then CARGA <= '1';
                        end if;
                        MCE <= '1';
                    end if;
						  
					if(PARO = '1') then
					    MCE <= '0';
					    MB <= '0';
					elsif (PARO /= PP) then
						MCE <= '1';
						MB <= '1';
					end if;

                    if((CDE = '1' and CDEant = '0') or (CB = '1' and CBant = '0')) then CARGA <= '0';
                    end if;

                    -- MPTI - Transportador a izquierda
                    if((CDE = '0' and CDEant = '1') or (CB = '0' and CBant = '1')) then MPTI <= '1';
                    end if;

                    if(PE = '1') then MPTI <= '0';
                    end if;

                    -- MPTD - Transportador a derecha
                    if(CPE = '0' and CPEant = '1' and PE = '1') then MPTD <= '1' after 1 sec;
                    end if;

                    if(PB = '1' and PBant = '0' and CARGA = '1') then
                        MPTD <= '0';
                        MPTD <= '1' after 30 sec;
                    end if;
						  
					if(PB = '0' and PBant = '1') then
						if (B = '1') then PCORRECTO <= '1';
                        else PCORRECTO <= '0';
                        end if;
					end if;

                    if(PPS = '1' and PPSant = '0') then MPTD <= '0';
                    end if;

                    -- MPCU - MPCD- Cinta en transportador hacia arriba (peso incorrecto) o abajo (peso correcto)
                    if(PPS = '1' and PPSant = '0') then
                        if(PCORRECTO = '0') then MPCU <= '1' after 300 ms;
                        else MPCD <= '1' after 300 ms;
                        end if;
                    end if;

                    if(CPE = '0' and CPEant = '1') then MPCU <= '0';
                    end if;

                    if(CB = '0' and CBant = '1') then MPCD <= '0';
                    end if;

                    -- MCD - Cinta D
                    if(CDE = '1' and CDEant = '0') then MCD <= '1';
                    end if;

                    if(CDS = '0' and CDSant = '1') then MCD <= '0';
                    end if;

                    -- Fin funcionamiento automatico
                else
                    -- Funcionamiento manual
                    if(PEM = '1' and PEMant = '0') then MCE <= not MCE;
                    end if;

                    if(PDER = '1') then MPTD <= '1';
                    else MPTD <= '0';
                    end if;

                    if(PIZQ = '1') then MPTI <= '1';
                    else MPTI <= '0';
                    end if;

                    if(PTU = '1') then MPCU <= '1';
                    else MPCU <= '0';
                    end if;

                    if(PTD = '1') then MPCD <= '1';
                    else MPCD <= '0';
                    end if;

                    if(PDM = '1' and PDMant = '0') then MCD <= not MCD;
                    else MCD <= MCD;
                    end if;
                    -- Fin funcionamiento manual
                end if;
            else
                -- Estado de emergencia
                MCE <= '0';
                MPTI <= '0';
                MPTD <= '0';
                MPCU <= '0';
                MPCD <= '0';
                MCD <= '0';
                MB <= '0';
            end if;
        end if;   
		  
		  -- Asignacion a salidas
        SMCE <= MCE;
        SMPTI <= MPTI;
        SMPTD <= MPTD;
        SMPCU <= MPCU;
        SMPCD <= MPCD;
        SMCD <= MCD;
        SMB <= MB;
        LEM <= SEM;

		PMant <= PM;
        PAant <= PA;
        CEant <= CE;
        PEant <= PE;
        CDEant <= CDE;
        CPEant <= CPE;
        CBant <= CB;
        PEMant <= PEM;
        PDMant <= PDM;
		PBant <= PB;
		PPSant <= PPS;
		CDSant <= CDS;
		PPant <= PP;
    end process;
end Behavioral;
