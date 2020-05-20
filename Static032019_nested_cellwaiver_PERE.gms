


$ontext
The identical model is meant to test the scenario under which the following parameters of FFV are identical to the cv
1. ic, keep lower value of cv
2. vc, keep lower value of FFV
3. MPG, keep value of cv with higher MPG
*4. or blend constraint removed for cv.
* Difference exists in age distribution, and existing stock
$offtext


$Oneolcom
$eolcom //
sets
 vehicle /CVS,FFV,HBV,BEV,PHEV,CNG/
 vehicle2(vehicle) /CVS, FFV/
 t /T1*T36/
 t2(t) /t1*t25/
 age /age1*age24/     //ZHJ: time node set at end of the year during which the car was bought is at age of 1.
 yr /2010*2050/
 s senarios /1*50/
 costs category of costs /IC, OM, FC, TV/ //IC: initial cost; OM: operational & management; FC: fuel costs; TV: terminal value
* fuel /gas, eth/
 item /IC, OM, En/
* Ene  /Gas,Eth,E10/
 fuel /gas, ETH, elec, NG,E10/
 ethblend /E10, E85/
 rin /D3,D4,D6/
;

alias (age,age2)

Parameters IC(vehicle)  dollar in setting up the model (Initial cost)
/CVS   34000
 FFV   34000
 HBV 38000
 BEV 54000
 CNG 27000
 PHEV 38000/


VC(vehicle) dollar per mile in fuel cost maintainence cost (Varaible cost)
/CVS 0.0538
 FFV 0.0538
 HBV 0.096
 BEV 0.07
 CNG 0.12
 PHEV 0.3/
*BEV from the appendix table A1.However, the BEV lifetime maintainence cost was from 0.30-0.60
*$1.2/gge gasoline gallon equivalent for CNG
*1 gge = 114000 BTU per gallon
*MGF(CVS)=25 mile/gallon                         I
*The VC(CNG) per mile =$1.2 per gge/25 mile per gallon= $ 0.05/mile

Vstock(vehicle,t) #vehicles in million based on the ORNL Transportation Energy Data Book Year 2007 and FFV from AEO 2009 data (except HBV)
/CVS.t1       217.71
FFV.t1        4.74
HBV.t1        0.05
BEV.t1        0.07
CNG.t1        0.12
PHEV.t1       0.3
/;


parameter Survivability(age)  the probability of a vehicle next year to get scrappaged given its age
/age1        0.995
age2        0.993
age3        0.990
age4        0.984
age5        0.975
age6        0.968
age7        0.958
age8        0.948
age9        0.939
age10       0.930
age11       0.893
age12       0.840
age13       0.823
age14       0.804
age15       0.796
age16       0.782
age17       0.780
age18       0.770
age19       0.769
age20       0.767
age21       0.767
age22       0.767
age23       0.767
age24       0.767
/;
*Since gallon per vehicle was not a good estimator in the market, VMT per vehicle might be good.
$ontext
GasCons(vehicle) gallon (gge) per vehicle per year zhj:assumption
/CVS 1024
 FFV 114
 HBV 6786
 BEV 6000
 CNG 6000
/;
*first 3 from the output of RFSRPS scenario based on 2013 Fuelsupply/vechile number.

$offtext



parameter avgVMT2(vehicle,age) Highest VMT capacity that a vehicle can drive;
avgVMT2(vehicle,age) =12500; //to test whether we have a quicker input of the new vehicles.

avgVMT2(vehicle,age)$(ord(age)gt 4 and ord(age)lt 15)=12500;

avgVMT2(vehicle,age)$(ord(age)gt 14)=10000;

*avgVMT2('cvs')=avgVMT2('cvs')-513 ;



Table Agedist(age,vehicle) From 2009 National Houshold Transportation Survey FFV are basically the same with VIO data
             CVS        FFV
age1        0.068      244331
age2        0.073      114209
age3        0.073      53970
age4        0.071      85943
age5        0.064      67285
age6        0.052      50736
age7        0.050      34563
age8        0.043      35001
age9        0.057      55848
age10        0.057     20648
age11        0.055     12733
age12        0.053     62966
age13        0.048     11816
age14        0.043     3658
age15        0.037     4594
age16        0.034     3009
age17        0.030
age18        0.023
age19        0.019
age20        0.016
age21        0.011
age22        0.011
age23        0.008
age24        0.006
;



Agedist(age,"FFV")= Agedist(age,"FFV")/SUM(AGE2,Agedist(age2,"FFV"));



parameter
BaseSTOCK(vehicle,age,t)
EndTurnoverM(vehicle,age,t);

BaseSTOCK(vehicle,age,'t1')=Vstock(vehicle,'t1')*Agedist(age,vehicle);
display BaseSTOCK;
*EndTurnoverM(vehicle,age,t)=150000;




$INCLUDE VMTGAS_2007_fuelDemand_PERE_0320.gms

Parameters
disc discount factor /0.04/
cardinal total years of simulation
EndNewV(t,vehicle)
Depr(age) Annual depreciation rate "NADA_WhitePaper_VolatilityInUsedVehicleDepreciation"
/
age1        1.00
age2        0.85
age3        0.72
age4        0.61
age5        0.52
age6        0.47
age7        0.42
age8        0.38
age9        0.34
age10       0.33
age11       0.31
age12       0.29
age13       0.28
age14       0.27
age15       0.25
age16       0.24
age17       0.22
age18       0.21
age19       0.20
age20       0.20
age21       0.19
age22       0.18
age23       0.16
/
;

*cardinal=ord(t);
EndNewV(t,vehicle)=0;

Parameter Ethtarget(t);
Ethtarget(t)=7000+1300*(ord(t)-1);

TABLE blendw(T,ethblend) maximum ethanol use for vehicle type (here in this case is the fixed rate)
           E10        E85
T1       0.03266
T2       0.03718
T3       0.03798
T4       0.07968
T5       0.08408
T6       0.08597
T7       0.08780
T8       0.08757
T9       0.09175
T10      0.096324
T11      0.1
T12      0.1
;
blendw(T,'E85')=0.74;
blendw(T,'E10')$(ord(t) ge 13)=0.1;
parameter EnergycoefEth(T,ethblend);

EnergycoefEth(T,ethblend)=1-blendw(T,ethblend)/3;

Parameter mineth minimum ethanol use for gas blend as additive /0.035/;

set category /total, BBD, CELL, ADVANCED/

Table  Blendrate(T,*)   from 2007 to 2040
*Calculated from blendrate equation using the base model RFS scenario
          total            BBD             CELL
T1        0.028489        0.003908
T2        0.031809        0.003552
T3        0.035238        0.006136        0.000034
T4        0.071082        0.007719        0.000032
T5        0.072775        0.006325        0.000035
T6        0.077655        0.007919        0.000046
T7        0.083380        0.010180        0.000032
T8        0.085580        0.013006        0.000176
T9        0.089628        0.013871        0.000657
T10        0.094277        0.015284        0.001233
T11        0.098683        0.016168        0.001676
T12        0.099724        0.017037        0.001558
T13        0.097961        0.015442        0.001246
T14        0.099635        0.016324        0.001692
T15        0.100747        0.017212        0.001574
T16        0.101915        0.017290        0.002294
T17        0.106057        0.020132        0.003076
T18        0.107135        0.020392        0.003512
T19        0.108030        0.020481        0.003951
T20        0.108957        0.020576        0.004395
T21        0.109878        0.020670        0.004843
T22        0.110457        0.020698        0.005277
T23        0.111398        0.020794        0.005732
T24        0.112331        0.020887        0.006189
T25        0.113223        0.020972        0.006648

;

parameter blendrate_expost(T,*);


$Gdxin static030419_nested_cellwaiver_test
$load blendrate_expost
$Gdxin
*Blendrate(T,category) =  blendrate_expost(T,category) ;

parameter Blend_bbd(T) in billion into million
/
t1    1.9
t2    2
t3    2.1
t4    2.1
t5    2.43
t6    2.45
/;

Blend_bbd(T)$(ord(t) gt 6)=2.45;
Blend_bbd(T)=Blend_bbd(T)*1000;
Blend_bbd(T)$(ord(t)gt 25)= Blend_bbd('t25');

parameter QethMandate(T) Quantity mandate billion gallon
/
T1    14.5
T2    15
T3    15
T4    15
T5    15.76
T6    16.52
T7    17.29
T8    18.05
T9    18.81
T10   19.57
T11   20.33
T12   21.10
T13   21.86
T14   22.62
T15   23.38
T16   24.14
T17   24.90
T18   25.67
T19   26.43
T20   27.19
T21   27.95
T22   28.71
T23   29.48
T24   30.24
T25   31.00
/;

QethMandate(T)=QethMandate(T)*1000;
QethMandate(T)$(ord(t)gt 25)=QethMandate('t25');


parameter CELLMandate(T) statutory volumn by mandate million gallon
/

t1        230
t2        311
t3        288
t4        418
t5        1160
t6        1902
t7        2644
t8        3386
t9        4128
t10       4870
t11       5612
t12       6354
t13       7096
t14       7838
t15       8580
t16       9322
t17       10064
t18       10806
t19       11548
t20       12290
t21       13032
t22       13774
t23       14516
t24       15258
t25       16000
/  ;

CELLMandate(T)$(ord(t)gt 25)=CELLMandate('t25');


parameter CELLMandate_RM(T) final rulemaking volumn gallon
/
t1        230
t2        311
t3        288
t4        418
t5        557
t6        633
t7        709
t8        785
t9        861
t10        937
t11        1013
t12        1089
t13        1165
t14        1241
t15        1317
t16        1393
t17        1469
t18        1545
t19        1621
t20        1697
t21        1773
t22        1849
t23        1925
t24        2001
t25        2077

/ ;
CELLMandate_RM(T)$(ord(t)gt 25) =CELLMandate_RM('T25');


TABLE Qmandate(T,category)
     BBD    cell        Advanced      Total
T1   0.495   0          0.03          4.7
T2   0.45    0          0.03          5.4
T3   0.774   0.0065     0.6           6.1
T4   0.975   0.006      0.95          12.95
T5   0.8    0.0066      1.35          13.95
T6   1      0.0087      2             15.2
T7   1.28   0.006       2.75          16.55
T8   1.63   0.033       2.67          16.28
T9   1.73   0.123       2.88          16.93
T10  1.9    0.23        3.61          18.11
T11  2      0.311       4.28          19.28
T12  2.1    0.288       4.29          19.29
;
Qmandate(T,category)=Qmandate(T,category)*1000 ;

Qmandate(T,'bbd')$(ord(t) gt 12)= Blend_bbd(T-12);
Qmandate(T,'cell')$(ord(t) gt 12)= CELLMandate_RM(T-12);
Qmandate(T,'total')$(ord(t) gt 12)=QethMandate(T);
Qmandate(T,'Advanced') $(ord(t) gt 12)= Qmandate(T,'total')-15000;
Qmandate(T,'bbd')=Qmandate(T,'bbd')*1.5;

parameter cellwaiverPrice(t)  THe price before 2010 are calculated 3.25-wholesale gas price from link below
*https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=PET&s=EMA_EPM0_PWG_NUS_DPG&f=A
/
t1 1.068
t2 0.664
t3 1.483
t4 1.56
t5 1.13
t6 0.78
t7 0.42
t8 0.49
t9 0.64
t10 1.33
t11 2
t12 1.96
t13 1.77
/;

cellwaiverPrice(t)$(ord(t) gt 13)=1.77;

parameter bbdtaxcredit(t) bbd tax credit
/
t1  0
t2  1
t3  1
t4  0
t5  0
t6  1
t7  1
t8  1
t9  1
t10 1
t11 1
t12 0
/                 ;

bbdtaxcredit(t)$(ord(t) gt 12)=1;
*bbdtaxcredit(t)=0;


parameter RVO_MANDATE(t,RIN);
RVO_MANDATE(t,'D4')= Qmandate(T,'bbd');
RVO_MANDATE(t,'D6')=Qmandate(T,'total')-Qmandate(T,'advanced');
RVO_MANDATE(t,'D3')= Qmandate(T,'cell');





parameter ethsub per gallon subsidy /0.51/ ;

parameter blendcost(*) linear blending cost from the avg estimates from the nonlinear model;

blendcost('Dieselfuel')=0.87;
blendcost('E10')=0.165;
blendcost('E85')=0.56;//0.22;//0.264;





*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------

positive Variables
NEWVEHICLE(vehicle,t) Newly bought vehicle(million)
VMTS(T,vehicle,age) VMT consumed by types of vehicles (million)

NEWSTOCK(vehicle,age,t) New vehicle stock after one year of vehicle shift (million)
MILE_DEMANDWEIGH(T,nogrid)
Gasohol_DEMANDWEIGH(T,nogrid)
GAS_SUPWEIGH(T,gassource,point)
Elec_SUPWEIGH(T,point)
NG_SUPWEIGH(T,point)
ETH_SUPWEIGH(T,point)
FWEIGHT(iter)
FUELSUPPLY(T,FUEL,vehicle)   million gallon
ExEthConFFV(T)    million gallon
ROW_GASCONSUMP(T)
*Gassupply(gassource,t)
Ethsupply(t)

ROW_GASDEMWEIGH(T,nogrid)
EthXBLEND(T,vehicle)
TVMT(T)
TFUELSUPPLY(T,FUEL)
BlendedF(T,vehicle,ethblend)
Ethdemand(t)

**ZHY111818 Add the diesel demand and supply
PDSL_SUPWEIGH(t,point)
DSLMILE_DEMWEIGH(t,nogrid)
DSL_DEMWEIGH(t,nogrid)
DSLSUPPLY(t,diesel)
DSLMILECONS(t)
**ZHJ120218 Add the blending cost and BBD supply
BDSL_SUPWEIGH(t,nogrid)
TotDSL_BLDWEIGH(t,nogrid)
E10_BLDWEIGH(t,nogrid)
E85_BLDWEIGH(t,nogrid)
Dcode_in(t, RIN)
Dcode_out(t, RIN)
Dcode(t,RIN)
stock(t,RIN)
**zhj120718: add the cellulosic biofuel
CELLEth_SUPWEIGH(T,point)
cellEthsupply(t)
cellwaiver(t)

 vethsupply(t,vehicle2,ethblend)
Gassupply(t)
;

variables
WF total social welfare (in Millions)
;

Equations
OBJ Objective function
$ontext
VehicleBalance1(vehicle,age) Newly bought vehicles make up the vehicle deficiency with the turnoverR (in million)
Vehiclestock(vehicle,t)     The newly entered vehicle change the age distribution
Vehiclestockn(vehicle,age,t) The age distribution will change with the new input vehicles
VMTBalance(vehicle,age,T)
MILEDemACCOUNT(T) From BEPAM-E good enough to predict the future mix of different vehicles based on the VMT mix
MILEDemCONVEX(T)  From BEPAM-E
ROWGASCONSUMBAL(T)
ROWGASDEMCONVEX(T)
STOCKLIMIT(t,RIN)
$offtext
GASWeigh(T,gassource)               From BEPAM-E
GAS_BALANCE(T)            From BEPAM-E
Gas_prod(t)
*TermCarValue(vehicle)
*wall_BLENDMANDATE(T,vehicle)

ETHSUPPLY_WEIGH(T)
ETHSUPPLY_WEIGH_conv(T)
Eth_BALANCE(T)     based on gallon
*ETHLIMIT_LOW(T) Lower limit of ethanol mix
*Fuelbelnd(T,age,vehicle) Volumetric mix
GASOHOLPROD(T)
DSL_balance(t)
GasoholDemConvex(t)
DSLDemConvex(t)
DSLDemCONV(t)
*MILEPRODC(T)
*MILEPRODF(T)
PDSLSUPPLY(t)
PDSLWeigh(t)
*DSLMILEDemACC(t)
*DSLMILEDemCONV(t)
*DSLMILEPROD(t)
*BDSLSUPPLY(t)
*Eth_BALANCE2(T)
RFS_RMANDATE2(T)
RFS_RMANDATE2_bbd(t)
RFS_RMANDATE2_cell(t)
RIN4(T)
RIN6(T)
RIN3(T)
WAIVER(t)
*WAIVER2(t)
*WAIVER3(t)
*RFS_qMANDATE2_cell(t)
*RFS_qMANDATE2_bbd(t)
*RFS_QMANDATE2
cornlimit(t)
*RINSTOCK_in(T,RIN)
*RINSTOCK_out(T,RIN)

BDSLSUPPLY(t)
BDSLSUPPLY_CONV(t)
*DSLBLEND(t)
*DSLBLEND_CONV(t)
cellETHSUPPLY_WEIGH(T)
cellETHSUPPLY_WEIGH_conv(T)
*E85BLEND(T)
*E85BLEND_CONV(t)

*E10BLEND(T)
*E10BLEND_CONV(t)

$ontext
Blendf(T,vehicle,ethblend)
Blendf_e10(T,vehicle)
Blendf_e85(T)
$offtext
;




* Assuming the age distribution and turnover rate are consistant among different types of vehicles.
OBJ..                           WF =e= Sum(T$(ord(T)le card(t2) ),
                                       ( Sum((NOGRID), GasoholSurplus(nogrid,t)*Gasohol_DEMANDWEIGH(T,nogrid))
*Sum((NOGRID), MileSurplus(nogrid,t)*MILE_DEMANDWEIGH(T,nogrid))
*
*                                       +Sum(NOGRID, DSLMileSurplus(nogrid,t)*DSLMILE_DEMWEIGH(t,nogrid))
                                        +Sum(NOGRID, DSLDemSurplus(nogrid,t)*DSL_DEMWEIGH(t,nogrid))
                                       - Sum(NOGRID,BBDPS_grid(nogrid,t) *BDSL_SUPWEIGH(t,nogrid))

                                        -Sum(point,PDSLCostGrid(point,t)*PDSL_SUPWEIGH(t,point))

                                       -sum(point, EthCostGrid(point,t)*Eth_SUPWEIGH(T,point) )
                                        -sum(point, CELLEthCostGrid(point)*CELLEth_SUPWEIGH(T,point))

*                                       + sum(nogrid, Row_gassurplus(nogrid)* ROW_GASDEMWEIGH(T,nogrid))
                                       -Sum((point), GasCostGrid_us(point,t)*GAS_SUPWEIGH(T,'us',point))
                                       + Ethsupply(t)$(ord(t) le 5)*0.45  //Volumetric Ethanol Excise Tax credit
*sum((vehicle2,age),VMTs(T,vehicle2,age))*(MileA2(t) - 0.5*MileB*sum((vehicle2,age),VMTs(T,vehicle2,age)))
*                                       +  DSLMILECONS(t)*(DSLMileA + 0.5*DSLMileB*DSLMILECONS(t))

*                                       + (row_demandgasA - 0.5*row_demandgasB*ROW_GASCONSUMP(T))*ROW_GASCONSUMP(T)
*                                       -sum((vehicle2),IC(vehicle2)* NEWVEHICLE(vehicle2,t))
*                                       - SUM((vehicle2,age),VMTS(T,vehicle2,age)*VC(vehicle2))
*                                       -sum((vehicle2,age), NEWSTOCK(vehicle2,age,t))*1071
*                                       -sum(gassource,(Gassupply(gassource,t)- gas_interceptX(gassource))*0.5*(gas_intercept(gassource) +gas_slope(gassource)* Gassupply(gassource,t)))
*                 Petro diesel SUPPLY
*                                       - ( DSLSUPPLY(t,'pdsl')- PDSL_interceptX)*0.5*(PDSL_intercept+PDSL_slope* DSLSUPPLY(t,'pdsl'))

* Integrated form of the CES curve of BBD supply curve from Korting
* Cost of blending BBD and diesel into DF from Korting
*                                       -0.53*(sum(diesel,DSLSUPPLY(t,diesel))/1000)**(1.25)*1000
*                                       -sum(nogrid,BlendCost_DSL(nogrid)*TotDSL_BLDWEIGH(t,nogrid) )
*                                       -sum(nogrid,BlendCost_E85(nogrid)*E85_BLDWEIGH(t,nogrid) )
*                                       -sum(nogrid,BlendCost_E10(nogrid)*E10_BLDWEIGH(t,nogrid))

                                        -sum((ethblend,vehicle),blendcost(ethblend)*BlendedF(T,vehicle,ethblend))
                                        -blendcost('Dieselfuel')*sum(diesel,DSLSUPPLY(t,diesel))
*                                       -0.32*(sum(vehicle2,BlendedF(T,vehicle2,'e10'))/1000)**(1.25)*1000-0.28*(sum(vehicle2,BlendedF(T,vehicle2,'e85'))/1000)**1.25*1000
*                                       -(Eth_intercept(t)+0.5* Eth_slope*Ethsupply(t) )*Ethsupply(t)
                                         -cellwaiver(t)*cellwaiverPrice(t)
                                        +DSLSUPPLY(t,'bdsl')*bbdtaxcredit(t)
*                                        - (0.2+0.43)*SUM(POINT,GAS_SUPWEIGH(T,'us',point)*Gaspoint('us',point))             //0.2 is the makeup ;0.43 is the excise tax including federal and state avg.
*                                       - (0.2+0.5)*sum(diesel,DSLSUPPLY(t,diesel))         //0.5 is the federal+state average retail tax  -->modified to 0.4
*                                       -(Ethsupply(t)- Eth_interceptX(t))*0.5*(Eth_intercept(t) +Eth_slope* Ethsupply(t))
))
*                                      +((1/(1+disc))**card(t2))*sum((vehicle2,age),0.85*IC(vehicle2)* NEWSTOCK(vehicle2,age,'t25')*Depr(age))

;

$ontext
TRANSCO2(T)$(ord(T)le 10)..   TransGHG(T) =E=  1/ton_kg*(
     Gas_CI(T)*Gas_ED/1000* sum((vehicle2),BlendedF(T,vehicle2)*(1-blendw(T,vehicle2)) ))

  +   (Ref_corneth*CornEth_CO2(T)/62.09 + ILUC_corneth*Eth_ED/1000)* QCorn_Eth(T)

  +   ILUC_celeth*Eth_ED/1000*

*cel_eth*(1-DSL_ETH_Ratio)
) ;
$offtext


*VehicleBalance1(vehicle2,age)$(ord(age) lt 24 )..   NEWSTOCK(vehicle2,age+1,'t1')=l= BaseSTOCK(vehicle2,age,'t1');
*Vehiclestock(vehicle2,t)$(ord(T)le card(t2) )..      (1/(1+disc))**(Ord(T)-1)*NEWSTOCK(vehicle2,'age1',t)=e= (1/(1+disc))**(Ord(T)-1)*NEWVEHICLE(vehicle2,t) ;
*Vehiclestockn(vehicle2,age,t)$(ord(T) ge 2 and ord(age) ge 2 and ord(T)le card(t2))..
*                                               (1/(1+disc))**(Ord(T)-1)*NEWSTOCK(vehicle2,age,t)=l= (1/(1+disc))**(Ord(T)-1)*NEWSTOCK(vehicle2,age-1,t-1)*Survivability(age-1);
*VMTBalance(vehicle2,age,T)$(ord(T)le card(t2))..    (1/(1+disc))**(Ord(T)-1)*NEWSTOCK(vehicle2,age,t)*avgVMT2(vehicle2,age) =g= (1/(1+disc))**(Ord(T)-1)*VMTS(T,vehicle2,age); //VMT per car was changed into an upper limit capacity 01/23/16

$ontext
MILEPRODC(T)$(ord(T)le 35)..               (1/(1+disc))**(Ord(T)-1)*sum(age,VMTs(T,'CVS',age)/MILEAGE2(t,'cvs',age)) =e= (1/(1+disc))**(Ord(T)-1)*(vethsupply(t,'CVS','e10')*2/3+Gassupply(t,'CVS','e10'));
MILEPRODF(T)$(ord(T)le 35)..               (1/(1+disc))**(Ord(T)-1)*sum(age,VMTs(T,'ffv',age)/MILEAGE2(t,'ffv',age)) =e= (1/(1+disc))**(Ord(T)-1)*(vethsupply(t,'ffv','e10')*2/3+Gassupply(t,'ffv','e10')+BlendedF(T,'ffv','E85')*EnergycoefEth(t,'E85'));

GAS_BALANCE(T)$(ord(T)le 35)..                 (1/(1+disc))**(Ord(T)-1)*sum((vehicle2,ethblend),Gassupply(t,vehicle2,ethblend) )+ (1/(1+disc))**(Ord(T)-1)*ROW_GASCONSUMP(t) =e=
                                               (1/(1+disc))**(Ord(T)-1)*sum((point,gassource), GAS_SUPWEIGH(T,gassource,point)*Gaspoint(gassource,point));
Eth_BALANCE(T)$(ord(T)le 35)..                (1/(1+disc))**(Ord(T)-1)*sum((vehicle2,ethblend),vethsupply(t,vehicle2,ethblend)) =e= (1/(1+disc))**(Ord(T)-1)* (Ethsupply(t)+cellEthsupply(t));

Blendf(T,vehicle2,ethblend)$(ord(T)le 35)..                  blendedf(T,vehicle2, ethblend) =E=  Gassupply(t,vehicle2,ethblend)+ vethsupply(t,vehicle2,ethblend);
Blendf_e10(T,vehicle2)$(ord(T)le 35)..                      vethsupply(t,vehicle2,'E10') =l= 0.10*(vethsupply(t,vehicle2,'E10')+Gassupply(t,vehicle2,'E10'));
Blendf_e85(T)$(ord(T)le 35)..                   vethsupply(t,'FFV','E85') =e= 0.85*( vethsupply(t,'FFV','E85')+Gassupply(t,'FFV','E85'));
$offtext
*$ontext
GASOHOLPROD(T)$(ord(T)le card(t2))..               sum(nogrid,Gasohol_DEMANDWEIGH(T,nogrid)*GasoholGrid(nogrid) )=e= blendedf(t,'cvs','e10')* EnergycoefEth(t,'E10')+sum(ethblend,blendedf(t,'ffv',ethblend)* EnergycoefEth(t,ethblend));    //(vethsupply(t,'CVS','e10')*2/3+Gassupply(t,'CVS','e10'));
*MILEPRODF(T)$(ord(T)le card(t2))..               sum(age,VMTs(T,'ffv',age)/MILEAGE2(t,'ffv',age)) =e=;  // (vethsupply(t,'ffv','e10')*2/3+Gassupply(t,'ffv','e10')+BlendedF(T,'ffv','E85')*EnergycoefEth(t,'E85'));
*DSLMILEDemACC(t)$(ord(T) le card(t2))..   DSLMILECONS(t) =e= sum(NOGRID, DSLMILE_DEMWEIGH(t,nogrid)*DSLMileGrid(nogrid,t));
DSLDemCONV(t)$(ord(T) le card(t2))..           sum(NOGRID, DSL_DEMWEIGH(t,nogrid))=e=1;
DSL_balance(t)$(ord(T) le card(t2))..       sum(NOGRID, DSL_DEMWEIGH(t,nogrid)*DSLDemGrid(nogrid,t))=E= sum(diesel,DSLSUPPLY(t,diesel));

Gas_prod(t)$(ord(T)le card(t2))..               Gassupply(t) =e=sum((point), GAS_SUPWEIGH(T,'us',point)*Gaspoint('us',point));
GAS_BALANCE(T)$(ord(T)le card(t2))..             sum((vehicle2,ethblend),blendedf(t,vehicle2,ethblend)*(1-blendw(t,ethblend)))=e=  Gassupply(t);
//                                               (1/(1+disc))**(Ord(T)-1)*sum((vehicle2,ethblend),blendedf(t,vehicle2,ethblend)*(1-blendw(t,ethblend)))+ (1/(1+disc))**(Ord(T)-1)*ROW_GASCONSUMP(t) =e=                   //Gassupply(t,vehicle2,ethblend)
//                                               (1/(1+disc))**(Ord(T)-1)*sum((point,gassource), GAS_SUPWEIGH(T,gassource,point)*Gaspoint(gassource,point));
Eth_BALANCE(T)$(ord(T)le card(t2))..                sum((vehicle2,ethblend),blendedf(t,vehicle2,ethblend)*blendw(t,ethblend)) =e=  (Ethsupply(t)+cellEthsupply(t));
*$offtext

**zhj120218 : Add the linearization
*MILEDemCONVEX(T)$(ord(T)le card(t2) )..              sum(NOGRID, MILE_DEMANDWEIGH(T,nogrid))=e=1;
*MILEDemACCOUNT(T)$(ord(T)le card(t2) )..             sum((age,vehicle2), VMTs(T,vehicle2,age))=g= sum(NOGRID, MILE_DEMANDWEIGH(T,nogrid)*MileGrid(nogrid));

GasoholDemConvex(T)$(ord(T)le card(t2) )..           sum(nogrid,Gasohol_DEMANDWEIGH(T,nogrid)) =e=1;
DSLDemConvex(T)$(ord(T)le card(t2) )..               sum(nogrid,DSL_DEMWEIGH(t,nogrid)) =e=1;
GASWeigh(T,gassource)$(ord(T)le card(t2))..          sum(point,GAS_SUPWEIGH(T,gassource,point)) =e= 1;
*ROWGASCONSUMBAL(T)$(ord(T)le card(t2))..             ROW_GASCONSUMP(T) =e= sum(nogrid, Row_gasGrid(nogrid)*ROW_GASDEMWEIGH(T,nogrid));
*ROWGASDEMCONVEX(T)$(ord(T)le card(t2))..             sum(nogrid, ROW_GASDEMWEIGH(T,nogrid))=E=1;
ETHSUPPLY_WEIGH(T)$(ord(T)le card(t2) )..             sum(point,Ethpoint(point)*Eth_SUPWEIGH(T,point)) =e= Ethsupply(t);
ETHSUPPLY_WEIGH_conv(T)$(ord(T)le card(t2) )..       sum(point,Eth_SUPWEIGH(T,point)) =e= 1;
cellETHSUPPLY_WEIGH(T)$(ord(T)le card(t2) )..            sum(point,cellEthpoint(point)*cellEth_SUPWEIGH(T,point)) =e= cellEthsupply(t);
cellETHSUPPLY_WEIGH_conv(T)$(ord(T)le card(t2) )..      sum(point,cellEth_SUPWEIGH(T,point)) =e= 1;



RFS_RMANDATE2(T)$(ord(T) le card(t2))..              sum(rin,DCODE(T,rin)) =g=Blendrate(T,'total')*(Gassupply(t)+DSLSUPPLY(t,'pdsl'));              //
RFS_RMANDATE2_bbd(T)$(ord(T) le card(t2))..          (DCODE(T,'D4'))=g= Blendrate(T,'BBD')*(Gassupply(t)+DSLSUPPLY(t,'PDSL'));
RFS_RMANDATE2_cell(T)$(ord(T) le card(t2))..           (cellwaiver(t)+DCODE(T,'D3'))=g= Blendrate(T,'CELL')*(Gassupply(t)+DSLSUPPLY(t,'PDSL'));

*RFS_QMANDATE2(T)$(ord(T) le card(t2))..              (1/(1+disc))**(Ord(T)-1)*sum(rin,DCODE_out(T,rin))   =g=  (1/(1+disc))**(Ord(T)-1)*( Qmandate(T,'total')-(Qmandate(T,'advanced')-Qmandate(T,'BBD')-Qmandate(T,'cell')));//-(cellMandate(T)- CELLMandate_RM(T));             //
*RFS_qMANDATE2_bbd(T)$(ord(T) le card(t2))..          (1/(1+disc))**(Ord(T)-1)*DCODE_out(T,'d4')=g=  (1/(1+disc))**(Ord(T)-1)*Qmandate(T,'BBD');   //(1/(1+disc))**(Ord(T)-1)*
*RFS_qMANDATE2_cell(T)$(ord(T) le card(t2))..         (1/(1+disc))**(Ord(T)-1)* (DCODE_out(T,'d3')+cellwaiver(t))=g= (1/(1+disc))**(Ord(T)-1)* Qmandate(T,'CELL');      //(1/(1+disc))**(Ord(T)-1)*

RIN4(T)$(ord(T) le card(t2))..                    (DCODE(T,'d4')) =e=  1.5*DSLSUPPLY(t,'bdsl');
RIN6(T)$(ord(T) le card(t2))..                     (DCODE(T,'d6')) =e=   Ethsupply(t);
RIN3(t)$(ord(T) le card(t2))..                   (DCODE(T,'d3')) =e=  (cellEthsupply(t));
WAIVER(t)$(ord(T) le card(t2))..                  cellwaiver(t) =l=  (cellMandate(T)- CELLMandate_RM(T));
*WAIVER2(t)$(ord(T) le 25)..                     (1/(1+disc))**(Ord(T)-1)*(+DCODE_out(T,'D3')) =G=  (1/(1+disc))**(Ord(T)-1)*cellMandate(T);
*WAIVER3(t)$(ord(T) le 25)..                     (1/(1+disc))**(Ord(T)-1)*  SUM(RIN,DCODE_out(T,RIN)) =g= (1/(1+disc))**(Ord(T)-1)* (QethMandate(T)+Blend_bbd(T));
*RINSTOCK_IN(T,RIN)$(ord(T) le card(t2))..                   (1/(1+disc))**(Ord(T)-1)*( DCODE_in(T,rin)+stock(t-1,RIN))=E=(1/(1+disc))**(Ord(T)-1)*(stock(t,RIN)+DCODE_OUT(T,rin));   //   DCODE_in(T,rin) =e= DCODE_out(T,rin);//
*RINSTOCK_OUT(T,RIN)$(ord(T) le card(t2))..                 (DCODE_in(T,rin))=G=DCODE_OUT(T,rin);

*STOCKLIMIT(t,RIN)$(ord(T) le card(t2))..                  DCODE_in(T,rin) =L=  RVO_MANDATE(t,rin)*0.2;
CORNLIMIT(T)$(ord(T) le card(t2))..                    Ethsupply(t)=l=  15000;


**zhj111818:add DSLmile demand and pdsl supply
PDSLSUPPLY(t)$(ord(T) le card(t2))..      DSLSUPPLY(t,'pdsl') =e= sum(point, PDSL_SUPWEIGH(t,point)*PDSLpoint(point));
PDSLWeigh(t)$(ord(T) le card(t2))..       sum(point,PDSL_SUPWEIGH(t,point)) =e= 1;

**ZHJ120218:Add BDSL supply curve and blending cost

BDSLSUPPLY(t)$(ord(T) le card(t2))..         DSLSUPPLY(t,'bdsl') =e= sum(NOGRID,BDSL_SUPWEIGH(t,nogrid)* BDSL_grid(nogrid));
BDSLSUPPLY_CONV(t)$(ord(T) le card(t2))..   sum(NOGRID,BDSL_SUPWEIGH(t,nogrid))=E=1;
$ontext
DSLBLEND(t)$(ord(T) le card(t2))..         sUM(DIESEL,DSLSUPPLY(t,DIESEL)) =e= sum(NOGRID,TotDSL_BLDWEIGH(t,nogrid)* TotDSL_grid(nogrid));
DSLBLEND_CONV(t)$(ord(T) le card(t2))..     sum(NOGRID,TotDSL_BLDWEIGH(t,nogrid))=E=1;

E85BLEND(T)$(ord(T) le card(t2))..          sum(vehicle2,BlendedF(T,vehicle2,'e85')) =e= sum(NOGRID,E85_BLDWEIGH(t,nogrid)* E85_grid(nogrid));
E85BLEND_CONV(t)$(ord(T) le card(t2))..     sum(NOGRID,E85_BLDWEIGH(t,nogrid))=E=1;

E10BLEND(T)$(ord(T) le card(t2))..          sum(vehicle2,BlendedF(T,vehicle2,'e10')) =e=  sum(NOGRID,E10_BLDWEIGH(t,nogrid)* E10_grid(nogrid));
E10BLEND_CONV(t)$(ord(T) le card(t2))..    sum(NOGRID,E10_BLDWEIGH(t,nogrid))=E=1;
$offtext





*BDSLSUPPLY(t)$(ord(T) le 34)..        DSLSUPPLY(t,'bdsl')=e=
// sum(secondary$OiltoDiesel(secondary),QBOIL_DSL(period,secondary))+ QWGRS_DSL(period)+ QBMASS_DSL(period);

BlendedF.FX(T,'CVS','e85')=0;
stock.fx('t1',rin)=0;
model Vehicles /all/;


option limcol=30;
Vehicles.OptFile=1;
Vehicles.DictFile = 4;
solve Vehicles MAXIMIZING WF USING LP;


PARAMETERs
enPrice(t,*,*) dollar per gal
EndVMT(t,vehicle)
EndGAS(t,*)
EndE10(t,*)
EndEth(t,*)
EndNewstock(t,vehicle)
Instrument(t,*,*)       //energy equivalent base
Instrument_age(t,*,*,*)
EndVMT(t,vehicle)
EndFR(t,*)  the ETHANOL rate used by the vehicle
EndSS(*)
EndNewv(t,vehicle)
alpha(t) energy equivalent coefficient of gallon E10
BlendV(t) Blend rate from expost calculation
AgeVstock(t,vehicle2,age)
EndAvgVMT(t,vehicle,age)
output2007(*)
TotGHG(t)
Instrument_out(*)
eNDFUEL(T,*)
EarlyRetired(vehicle2,*,t)
EndAvgVMT_aget(vehicle2,*)
count(vehicle2,*)
blendrate_bbd_expost(t)

EnergycoefEthv(T2,vehicle)
ENDRINFLOW(T,RIN,*)
;

*EnergycoefEthv(T2,vehicle2)=   vethsupply.l(t2,vehicle2,'E10') /(vethsupply.l(t2,vehicle2,'E10')+Gassupply.l(t2,vehicle2,'E10'));


*EndNewstock(t2,vehicle2)= sum(age, NEWSTOCK.l(vehicle2,age,t2));
*EndVMT(t2,vehicle2)= sum(age, VMTs.l(T2,vehicle2,age));
*EndNewv(t2,vehicle2)$(NEWVEHICLE.l(vehicle2,t2) ge 0.001)=NEWVEHICLE.l(vehicle2,t2);
*EndAvgVMT(t2,vehicle2,age2)$(NEWSTOCK.l(vehicle2,age2,t2) gt 0.001)=  VMTS.l(T2,vehicle2,age2)/NEWSTOCK.l(vehicle2,age2,t2);
*count(vehicle2,"under14")=sum((t2,age2)$(ord(age2) le 14 and EndAvgVMT(t2,vehicle2,age2) gt 0.001),1);
*count(vehicle2,"over15")=sum((t2,age2)$(ord(age2) ge 15 and EndAvgVMT(t2,vehicle2,age2) gt 0.001),1);
*EndAvgVMT_aget(vehicle2,"under14")=sum((t2,age2)$(ord(age2) le 14),EndAvgVMT(t2,vehicle2,age2))/count(vehicle2,"under14");
*EndAvgVMT_aget(vehicle2,"over15")=sum((t2,age2)$(ord(age2) ge 15),EndAvgVMT(t2,vehicle2,age2))/count(vehicle2,"over15");
*EarlyRetired(vehicle2,age,t)$(ord(T) ge 2 and ord(age) ge 2 and ord(T)le 34)=NEWSTOCK.l(vehicle2,age-1,t-1)-NEWSTOCK.l(vehicle2,age,t);
*EarlyRetired(vehicle2,age,'t1')=BaseSTOCK(vehicle2,age,'t1')-NEWSTOCK.l(vehicle2,age+1,'t1');
*EarlyRetired(vehicle2,'',t2)=sum(age, EarlyRetired(vehicle2,age,t2));


EndE10(t2,'total')= SUM(vehicle2,BlendedF.L(T2,vehicle2,'E10')) ;
EndE10(t2,'cvs')= BlendedF.L(T2,'cvs','E10') ;
EndE10(t2,'ffv')= BlendedF.L(T2,'ffv','E10') ;
EndEth(t2,'TOTAL')=Ethsupply.l(t2) +cellEthsupply.l(t2);
EndEth(t2,'E10')= SUM(vehicle2,BlendedF.L(T2,vehicle2,'e10')*blendw(T2,'e10'));
EndEth(t2,'E85')= SUM(vehicle2,BlendedF.L(T2,vehicle2,'e85')*blendw(T2,'e85')) ;

EndGas(t2,'total')=sum((vehicle2,ethblend),BlendedF.l(T2,vehicle2,ethblend)*(1-blendw(T2,ethblend)) );
EndGas(t2,"CVS")= sum((ethblend),BlendedF.l(T2,'cvs',ethblend)*(1-blendw(T2,ethblend)) );
EndGas(t2,"FFV")=  sum((ethblend),BlendedF.l(T2,'ffv',ethblend)*(1-blendw(T2,ethblend)) );
*EndGas(t2,"Net Export")=ROW_GASCONSUMP.l(t2)-sum((point), GAS_SUPWEIGH.l(T2,'row',point)*Gaspoint('row',point));



*ENPrice(t2,'GASMile','cons')=MileA2(t2) - MileB*sum((vehicle2,AGE),VMTs.l(T2,vehicle2,age));

ENPrice(t2,'E10_gge',"cons")=GASOHOLPROD.m(t2) ;// ENPrice(t2,'GASMile','cons')*MILEAGE2(t2,'cvs','AGE1');
//SUM(AGE,(MileA2(t2) - MileB*sum((vehicle2,age2),VMTs.l(vehicle2,age2,T2)))*MILEAGE2(t2,'cvs',AGE))/SUM(AGE$MILEAGE2(t2,'cvs',AGE),1);//MILEPRODC.m(t2);
ENPrice(t2,'E85_gge',"cons")= GASOHOLPROD.m(t2); //ENPrice(t2,'GASMile','cons')*MILEAGE2(t2,'FFV','AGE1');


*ENPrice(t2,'E10_gge',"cons")=  MILEPRODC.m(t2);
//SUM(AGE,(MileA2(t2) - MileB*sum((vehicle2,age2),VMTs.l(vehicle2,age2,T2)))*MILEAGE2(t2,'cvs',AGE))/SUM(AGE$MILEAGE2(t2,'cvs',AGE),1);//MILEPRODC.m(t2);
*ENPrice(t2,'E85_gge',"cons")$BlendedF.L(T2,'ffv','E85')=  MILEPRODF.m(t2);
//SUM(AGE,(MileA2(t2) - MileB*sum((vehicle2,age2),VMTs.l(vehicle2,age2,T2)))*MILEAGE2(t2,'ffv',AGE))/SUM(AGE$MILEAGE2(t2,'ffv',AGE),1);
ENPrice(t2,'E85',"cons")=ENPrice(t2,'E85_gge',"cons")*EnergycoefEth(T2,'e85');
EnPrice(t2,'e10',"cons")=EnPrice(t2,'e10_gge',"cons")*EnergycoefEth(T2,'e10');
*Enprice(t2,'FFV_fuel_gge','cons')= (EnPrice(t2,'e10_gge',"cons")*EndE10(t2,'ffv')*alpha(t2)+EnPrice(t2,'eth_gge',"cons")*EndEth(t2,"FFV_BE")*2/3)/(EndE10(t2,'ffv')*alpha(t2)+EndEth(t2,"FFV_BE")*2/3);

ENPrice(t2,'GAS',"pro")=gas_intercept('US') +gas_slope_us(t2)* sum((point), GAS_SUPWEIGH.l(T2,'US',point)*Gaspoint('US',point)) ;
EnPrice(t2,'cornETH',"pro")=(Eth_intercept(t2) +Eth_slope(t2)*Ethsupply.l(t2));
EnPrice(t2,'cellETH',"pro")=(cellEth_intercept +cellEth_slope*cellEthsupply.l(t2));
EnPrice(t2,'ETH',"pro") = ( EnPrice(t2,'cornETH',"pro")* Ethsupply.l(t2)   +EnPrice(t2,'cellETH',"pro")*cellEthsupply.l(t2))/( Ethsupply.l(t2)+cellEthsupply.l(t2));


EnPrice(t2,'E10',"pro")= ((1-blendw(T2,'E10'))*ENPrice(t2,'GAS',"pro")+blendw(T2,'E10')*EnPrice(t2,'ETH',"pro"));
EnPrice(t2,'E85',"pro")= ((1-blendw(T2,'E85'))*ENPrice(t2,'GAS',"pro")+blendw(T2,'E85')*EnPrice(t2,'ETH',"pro"));
EnPrice(t2,'DIESEL',"pro")= PDSL_intercept(t2)+PDSL_slope_t(t2)*DSLSUPPLY.l(t2,'pdsl') ;
EnPrice(t2,'DIESEL',"CONS")=DSL_balance.m(t2); //(DSLMileA2(t2) + DSLMileB*DSLMILECONS.l(t2))* DSLMileage(T2);
EnPrice(t2,'BBD',"pro")=BDSLSUPPLY.m(t2); //( DSLSUPPLY.l(t2,'bdsl')/BBD_A/1000)**BBDelas ;
*EnPrice(t2,'DIESELMILE',"CONS")= DSLMileA2(t2)+ DSLMileB*DSLMILECONS.l(t2);
*EnPrice(t,"ROW_GAS_PRICE","PRO")=row_demandgasA - row_demandgasB*ROW_GASCONSUMP.l(T);    //same as producer price
EnPrice(t2,'D4',"PRO")= RIN4.m(T2);
EnPrice(t2,'D6',"PRO")= RIN6.M(T2);
EnPrice(t2,'D3',"PRO")= RIN3.M(t2);
ENPrice(t2,'E85_gge',"cons")=  ( 0.26*GAS_BALANCE.m(T2)+ 0.74* Eth_BALANCE.m(t2) +blendcost('E85'))/EnergycoefEth(T2,'e85'); //- (1-blendw(t2,'E85'))*(Blendrate(T2,'total')*RFS_RMANDATE2.M(T2)+Blendrate(T2,'BBD')*RFS_RMANDATE2_bbd.M(T2)+Blendrate(T2,'CELL') *RFS_RMANDATE2_cell.M(T2))

*EndVMT(t2,vehicle)= sum(age,VMTS.L(T2,vehicle,age));



EndFR(t2,'FFV')$sum(ethblend,BlendedF.l(T2,'ffv',ETHBLEND))=sum(ethblend,BlendedF.l(T2,'ffv',ETHBLEND)*blendw(t2,ethblend))/sum(ethblend,BlendedF.l(T2,'ffv',ETHBLEND));
EndFR(t2,'CVS')=blendw(t2,'E10');
EndFR(t2,'DF')$sum(diesel,DSLSUPPLY.l(t2,diesel))=DSLSUPPLY.l(t2,'bdsl')/sum(diesel,DSLSUPPLY.l(t2,diesel));
EndFR(t2,'eth')= sum((vehicle2,ethblend),BlendedF.l(T2,vehicle2,ETHBLEND)*blendw(t2,ethblend))/sum((ethblend,vehicle2),BlendedF.l(T2,vehicle2,ETHBLEND));
EndFR(t2,'E10RATE')= (Qmandate(T2,'total')-Qmandate(T2,'advanced')+Qmandate(T2,'cell')-RFS_RMANDATE2.L(T2))/sum((ethblend,vehicle2),BlendedF.l(T2,vehicle2,ETHBLEND));


EndFuel(t2,'totalgasohol')= blendedf.l(t2,'cvs','e10')* EnergycoefEth(t2,'E10')+sum(ethblend,blendedf.l(t2,'ffv',ethblend)* EnergycoefEth(t2,ethblend));
EndFuel(t2,'corneth')= ethSUPPLY.L(t2);


EndFuel(t2,'gas')= EndGas(t2,"total");
EndFuel(t2,'E10')= EndE10(t2,'total');
EndFuel(t2,'E85')= EndEth(t2,'E85');
EndFuel(t2,'DIESEL')$DSLSUPPLY.L(t2,'pdsl')=  DSLSUPPLY.L(t2,'pdsl');
EndFuel(t2,'BBD')$DSLSUPPLY.L(t2,'bdsl')=  DSLSUPPLY.L(t2,'bdsl');
EndFuel(t2,'totalDiesel')=  DSLSUPPLY.L(t2,'pdsl')+ DSLSUPPLY.L(t2,'bdsl');
EndFuel(t2,'cell')$DSLSUPPLY.L(t2,'bdsl')=  cellethSUPPLY.L(t2);

EndFuel(t2,'D4')= dcode.l(t2,'d4');
EndFuel(t2,'D3')= dcode.l(t2,'d3');
EndFuel(t2,'D6')= dcode.l(t2,'d6');
EndFuel(t2,'cellwaiver')= cellwaiver.l(t2);
EndFuel(t2,'RFSmandate_bbd')=  Qmandate(T2,'BBD') ;
EndFuel(t2,'RFSmandate_corn')= Qmandate(T2,'total')-Qmandate(T2,'advanced')  ;
EndFuel(t2,'RFSmandate_cell')=Qmandate(T2,'CELL') ;

ENPrice(t2,'blenders_B_elas','pro')=1/BBD_slope(t2)* ENPrice(t2,'BBD',"pro")/EndFuel(t2,'BBD');
ENPrice(t2,'blenders_B_dTC','pro')=(1/ENPrice(t2,'blenders_B_elas','pro')+1)* EnPrice(t2,'BBD',"pro");
ENPrice(t2,'blenders_E_elas','pro')=1/Eth_slope(t2)* ENPrice(t2,'corneth',"pro")/EndFuel(t2,'CORNETH');
ENPrice(t2,'blenders_E_dTC','pro')=(1/ENPrice(t2,'blenders_E_elas','pro')+1)* EnPrice(t2,'cornETH',"pro") ;

blendrate_expost(t2,'bbd')$(EndFuel(t2,'gas')+ EndFuel(t2,'DIESEL'))= Qmandate(T2,'BBD')/ (EndFuel(t2,'gas')+ EndFuel(t2,'DIESEL'));
blendrate_expost(T2,'total')$(EndFuel(t2,'gas')+ EndFuel(t2,'DIESEL')) =  ( Qmandate(T2,'total')-(Qmandate(T2,'advanced')-Qmandate(T2,'BBD')-Qmandate(T2,'cell')))/ (EndFuel(t2,'gas')+ EndFuel(t2,'DIESEL'));                        //
blendrate_expost(T2,'cell')$(EndFuel(t2,'gas')+ EndFuel(t2,'DIESEL')) =Qmandate(T2,'CELL')/ (EndFuel(t2,'gas')+ EndFuel(t2,'DIESEL'));


*$ontext
EndSS("CS_Gasohol") =
Sum(T$(ord(T)EQ 11 ),
                   Sum((NOGRID), GasoholSurplus(nogrid,t)*Gasohol_DEMANDWEIGH.l(T,nogrid))-GASOHOLPROD.m(T)* sum(nogrid,Gasohol_DEMANDWEIGH.l(T,nogrid)*GasoholGrid(nogrid) )
                 );
EndSS("CS_Diesel") =   Sum(T$(ord(T) EQ 11  ),  Sum(NOGRID, DSLDemSurplus(nogrid,t)*DSL_DEMWEIGH.l(t,nogrid))- DSL_balance.m(t)*sum(NOGRID, DSL_DEMWEIGH.l(t,nogrid)*DSLDemGrid(nogrid,t))); //DSLMILECONS.L(t)*(DSLMileA + 0.5*DSLMileB*DSLMILECONS.l(t)) - DSLMILECONS.l(t) *EnPrice(t,'DIESELMILE',"CONS")));


EndSS("PS_gas_dom")=  Sum(T$(ord(T)EQ 11 ),
*                          ENPrice(T,'GAS',"PRO")*Gassupply.l('us',t)-(Gassupply.l('us',t)- gas_interceptX('us'))*0.5*(gas_intercept('us') +gas_slope('us')* Gassupply.l('us',t)) //
                         ENPrice(T,'GAS',"PRO")*EndFuel(t,'gas')-Sum((point), GasCostGrid('us',point)*GAS_SUPWEIGH.l(T,'us',point))-DCODE.L(T,'d6')*RIN6.M(T)-DCODE.L(T,'d3')*RIN3.M(T)-cellwaiver.l(t)*cellwaiverPrice(t)
                         );
EndSS("PS_corneth")=    Sum(T$(ord(T)EQ 11 ),
                        (  0.45+EnPrice(T,'cornETH',"pro"))*Ethsupply.l(t)- sum(point, EthCostGrid(point,t)*Eth_SUPWEIGH.l(T,point) )  + DCODE.L(T,'d6')*RIN6.M(T) );

EndSS("PS_celleth")=    Sum(T$(ord(T) EQ 11 ),
                        EnPrice(T,'cellETH',"pro")*EndFuel(t,'cell')-sum(point, CELLEthCostGrid(point)*CELLEth_SUPWEIGH.l(T,point))  + DCODE.L(T,'d3')*RIN3.M(T));


EndSS("PS_Diesel")=  Sum(T$(ord(T) EQ 11 ),DSLSUPPLY.l(t,'pdsl')*EnPrice(t,'DIESEL',"pro")  -Sum(point,PDSLCostGrid(point,t)*PDSL_SUPWEIGH.l(t,point))-DCODE.L(T,'d4')*RIN4.M(T));     //
EndSS("PS_BBD")=    Sum(T$(ord(T) EQ 11 ), DSLSUPPLY.l(t,'bdsl')*EnPrice(t,'BBD',"pro")- Sum(NOGRID,BBDPS_grid(nogrid,t) *BDSL_SUPWEIGH.l(t,nogrid))  + DCODE.L(T,'d4')*RIN4.M(T)    );


EndSS("Blender")=  Sum(T$(ord(T) EQ 11 ),
                                   SUM(ethblend,SUM(VEHICLE,BlendedF.L(T,vehicle,ethblend))*ENPrice(t,ethblend,"CONS"))+ sum(diesel,DSLSUPPLY.L(t,diesel))*EnPrice(t,'DIESEL',"CONS")//+bbdtaxcredit(t)*DSLSUPPLY.l(t,'bdsl')

*                                 - GAS_BALANCE.m(t)* EndGas(t,'total')- Eth_BALANCE.m(T)*EndEth(t,'TOTAL') -DSL_balance.m(t)*DSLSUPPLY.l(t,'bdsl')-DSL_balance.m(t) *DSLSUPPLY.l(t,'Pdsl')
                                 - Gas_prod.m(t)* EndGas(t,'total')-(- ETHSUPPLY_WEIGH.m(t))*Ethsupply.l(t)- (-cellETHSUPPLY_WEIGH.m(T))*cellEthsupply.l(t)- BDSLSUPPLY.m(T)*DSLSUPPLY.l(t,'bdsl')-PDSLSUPPLY.m(T)*DSLSUPPLY.l(t,'Pdsl')
                                   -sum((ethblend,vehicle),blendcost(ethblend)*BlendedF.l(T,vehicle,ethblend)) -blendcost('Dieselfuel')*sum(diesel,DSLSUPPLY.l(t,diesel) )) ;

$ontext non-linear blending cost
  -0.53*(sum(diesel,DSLSUPPLY.L(t,diesel))/1000)**(1.25)*1000
   -0.32*(sum(vehicle2,BlendedF.L(T,vehicle2,'e10'))/1000)**(1.25)*1000
  -0.28*(sum(vehicle2,BlendedF.L(T,vehicle2,'e85'))/1000)**1.25*1000
$offtext non-linear blending cost

EndSS("PS_sum")= EndSS("PS_gas_dom")+EndSS("PS_corneth")+EndSS("PS_celleth")+EndSS("PS_Diesel")+EndSS("PS_BBD");
EndSS("CS_sum") = EndSS("CS_Gasohol")+EndSS("CS_Diesel");   //WF.L-EndSS("PS_gas_import","row")-EndSS("CS_gas_export","row")- EndSS("PS_sum","")- EndSS("TermV","");
EndSS("TS_US")=EndSS("CS_sum")+EndSS("PS_sum")+EndSS("Blender");
*AgeVstock(t2,vehicle2,age)= NEWSTOCK.l(vehicle2,age,t2);

EndSS("Blender_benefit")=  Sum(T$(ord(T) EQ 11 ),   SUM(ethblend,SUM(VEHICLE,BlendedF.L(T,vehicle,ethblend))*ENPrice(t,ethblend,"CONS"))+ sum(diesel,DSLSUPPLY.L(t,diesel))*EnPrice(t,'DIESEL',"CONS"));//+bbdtaxcredit(t)*DSLSUPPLY.l(t,'bdsl') );
EndSS("Blender_Cost")=  Sum(T$(ord(T) EQ 11 ),  - ENPrice(t,'GAS',"pro")* EndGas(t,'total')- ENPrice(t,'corneth',"pro")*Ethsupply.l(t)- ENPrice(t,'celleth',"pro")*cellEthsupply.l(t)- EnPrice(t,'BBD',"pro")*DSLSUPPLY.l(t,'bdsl')-EnPrice(t,'DIESEL',"pro") *DSLSUPPLY.l(t,'Pdsl') );

EndSS("Blender_RIN")=  Sum(T$(ord(T) EQ 11 ),     + DCODE.L(T,'d6')*RIN6.M(T) + DCODE.L(T,'d3')*RIN3.M(T)   + DCODE.L(T,'d4')*RIN4.M(T) );
EndSS("Blender_bLENDING")=  Sum(T$(ord(T) EQ 11 ),-sum((ethblend,vehicle),blendcost(ethblend)*BlendedF.l(T,vehicle,ethblend))
                                        -blendcost('Dieselfuel')*sum(diesel,DSLSUPPLY.l(t,diesel) )) ;





*$ontext
PARAMETER instruments_fuel(t,*);
instruments_fuel(t,'Ethanol_pergal')$(ord(t) le card(t2))= ((RIN6.m(T))*Ethsupply.l(T)+ RIN3.m(T)*cellEthsupply.l(T))/(Ethsupply.l(T)+cellEthsupply.l(T));
instruments_fuel(t,'gas_pergal')$(ord(t) le card(t2))= RFS_RMANDATE2.M(T)*Blendrate(T,'total')+RFS_RMANDATE2_cell.M(T)*Blendrate(T,'CELL')+RFS_RMANDATE2_BBD.M(T)*Blendrate(T,'BBD');

instruments_fuel(t,'E10_pergal')$(ord(t) le card(t2))= instruments_fuel(t,'Ethanol_pergal')*blendw(T,'E10')+(RFS_RMANDATE2.M(T)*Blendrate(T,'total')+RFS_RMANDATE2_BBD.M(T)*Blendrate(T,'BBD')+RFS_RMANDATE2_cell.M(T)*Blendrate(T,'CELL'))*(1-blendw(T,'E10'));
instruments_fuel(t,'E85_pergal')$(ord(t) le card(t2))= instruments_fuel(t,'Ethanol_pergal')*blendw(T,'E85')+(RFS_RMANDATE2.M(T)*Blendrate(T,'total')+RFS_RMANDATE2_BBD.M(T)*Blendrate(T,'BBD')+RFS_RMANDATE2_cell.M(T)*Blendrate(T,'CELL'))*(1-blendw(T,'E85'));
instruments_fuel(t,'BDF_pergal')$(ord(t) le card(t2) and sum(diesel,DSLSUPPLY.l(t,diesel)))=(-1.5*(RFS_RMANDATE2_BBD.M(T)+RFS_RMANDATE2.M(T))* DSLSUPPLY.l(t,'bdsl')+( RFS_RMANDATE2_BBD.M(T)*Blendrate(T,'BBD')+RFS_RMANDATE2.M(T)*Blendrate(T,'total'))* DSLSUPPLY.l(t,'pdsl'))/sum(diesel,DSLSUPPLY.l(t,diesel));
instruments_fuel(t,'BBD_pergal')$(ord(t) le card(t2))= 1.5*RIN4.M(T);
instruments_fuel(t,'D_pergal')$(ord(t) le card(t2))= RFS_RMANDATE2_BBD.M(T)*Blendrate(T,'BBD')+RFS_RMANDATE2.M(T)*Blendrate(T,'total')+RFS_RMANDATE2_cell.M(T)*Blendrate(T,'CELL');
instruments_fuel(t,'BDF_pergal')$(ord(t) le card(t2))= (instruments_fuel(t,'BBD_pergal')*DSLSUPPLY.l(t,'bdsl')+instruments_fuel(t,'D_pergal')*DSLSUPPLY.l(t,'pdsl'))/sum(diesel,DSLSUPPLY.l(t,diesel));

instruments_fuel(t,'RINonETH_pergal')$(ord(t) le card(t2))= ((RIN6.m(T))*Ethsupply.l(T)+ RIN3.m(T)*cellEthsupply.l(T))/(Ethsupply.l(T)+cellEthsupply.l(T));
instruments_fuel(t,'E10rin_pergal')$(ord(t) le card(t2))= instruments_fuel(t,'RINonETH_pergal')*0.1+instruments_fuel(t,'gas_pergal')*0.9;
instruments_fuel(t,'E85rin_pergal')$(ord(t) le card(t2))= instruments_fuel(t,'RINonETH_pergal')*blendw(T,'E85')+instruments_fuel(t,'gas_pergal')*(1-blendw(T,'E85'));


instruments_fuel(t,'E10_total')$(ord(t) le card(t2))= instruments_fuel(t,'E10_pergal')*sum(vehicle2,BlendedF.l(T,vehicle2,'e10'));
instruments_fuel(t,'E85_total')$(ord(t) le card(t2))= instruments_fuel(t,'E85_pergal')*sum(vehicle2,BlendedF.l(T,vehicle2,'e85'));
instruments_fuel(t,'BDF_total')$(ord(t) le card(t2))= instruments_fuel(t,'BDF_pergal')*sum(diesel,DSLSUPPLY.l(t,diesel));
instruments_fuel(t,'BBD_total')$(ord(t) le card(t2))= instruments_fuel(t,'BBD_pergal')*DSLSUPPLY.l(t,'bdsl');
instruments_fuel(t,'D_total')$(ord(t) le card(t2))= instruments_fuel(t,'D_pergal')*DSLSUPPLY.l(t,'pdsl');
instruments_fuel(t,'Revenue_Neutral')$(ord(t) le card(t2))= instruments_fuel(t,'E10_total')+instruments_fuel(t,'E85_total')+ instruments_fuel(t,'BDF_total');




*$ONTEXT
*Instrument(t2,'Tax_gas_BR',vehicle2)=RFS_BLENDMANDATE.m(t2,vehicle2)*BlendV(t2,vehicle2);  //equivalent to lambda in the algebraic model description
Instrument(t2,'tax_E10_gge','')=  instruments_fuel(t2,'E10_pergal') /EnergycoefEth(T2,'E10');
Instrument(t2,'Sub_E85_gge','')= instruments_fuel(t2,'E85_pergal') /EnergycoefEth(T2,'E85');
Instrument(t2,'Sub_FFV_gge','')= (instruments_fuel(t2,'E10_pergal')*BlendedF.L(T2,'ffv','e10')+ instruments_fuel(t2,'E85_pergal')* BlendedF.L(T2,'ffv','e85'))/sum(ethblend,BlendedF.L(T2,'ffv',ethblend)*EnergycoefEth(T2,ethblend));

Instrument(T2,'CV_TAX',AGE2)=avgVMT2('CVS',age2)/MILEAGE2(t2,'cvs',age2)*Instrument(t2,'tax_E10_gge','');
Instrument(T2,'FFV_SUB',AGE2)= avgVMT2('FFV',age2)/MILEAGE2(t2,'ffv',age2)*Instrument(t2,'Sub_FFV_gge','');


loop(t2,
loop(age2,

if( ord(t2) ge ord(age2),
*Condition2 vehicle newly purchased take the age1 value as the starting point, across t, then the NPV of t
Instrument_age(t2,'Sub_V','cvs',age2)=sum((t)$(ord(t)ge ord(t2) and ord(t) le 34 ),(1/(1+disc))**(Ord(T)-ORD(T2))*Instrument(T,'CV_TAX',age2+(Ord(T)-ORD(T2))));
Instrument_age(t2,'Sub_V','ffv',age2)=sum((t)$(ord(t)ge ord(t2) and ord(t) le 34 ),(1/(1+disc))**(Ord(T)-ORD(T2))*Instrument(T,'FFV_SUB',age2+(Ord(T)-ORD(T2))));

else
*Condition1 vehicle existing, take the t1 value, across different age
Instrument_age(t2,'Sub_V','cvs',age2)=sum((age)$(ord(age)ge ord(age2) and ord(age) le 24),(1/(1+disc))**(Ord(age)-ORD(age2))*Instrument(t2+(Ord(age)-ORD(age2)),'CV_TAX',AGE2));
Instrument_age(t2,'Sub_V','ffv',age2)=sum((age)$(ord(age)ge ord(age2) and ord(age) le 24),(1/(1+disc))**(Ord(age)-ORD(age2))*Instrument(t2+(Ord(age)-ORD(age2)),'FFV_SUB',AGE2));
);

);
);

Parameters Vinstrument(*,vehicle,*);
Vinstrument('condition1',vehicle,age2)=Instrument_age('t1','Sub_V',vehicle,age2);
Vinstrument('condition2',vehicle,t2)=(1/(1+disc))**(Ord(T2)-1)*Instrument_age(t2,'Sub_V',vehicle,'age1');



*ENPrice(t2,'E85_gge_postcalculation_2',"cons")= EnPrice(t2,'E85_gge',"pro")-instruments_fuel(t2,'gas_pergal')*0.15/EnergycoefEth(T2,'E85')+blendcost('E85')/EnergycoefEth(T2,'E85') ;


parameter calibrate(*);

calibrate('diesel (producer) price')= EnPrice('t11','DIESEL',"pro");
calibrate('biodiesel (producer) price')= EnPrice('t11','BBD',"pro");
calibrate('gasoline pro price')=  EnPrice('t11','gas',"pro");
calibrate('generic ethanol pro price')=  EnPrice('t11','eth',"pro");
*calibrate('CELL ethanol pro price')=  EnPrice('t1','cellETH',"pro");
calibrate('retail E85')=ENPrice('t11','E85_gge',"cons");
calibrate('retail E10')=ENPrice('t11','E10_gge',"cons");
calibrate('retail BF')=DSL_balance.m('t11');//ENPrice('t12','DIESEL',"cons");

*calibrate('D3 rin')= EnPrice('t4','D3',"PRO");
*calibrate('D4 rin')= EnPrice('t4','D4',"PRO");
*calibrate('D6 rin')= EnPrice('t4','D6',"PRO");
calibrate('diesel production')= EndFuel('t11','DIESEL')/1000;
calibrate('biodiesel production')= EndFuel('t11','BBD')/1000;
calibrate('gasoline production')= EndFuel('t11','gas')/1000;
calibrate('ethanol production')=  ( EndEth('t11','TOTAL') )/1000;
calibrate('corn ethanol')=Ethsupply.l('t11')/1000;
calibrate('cell ethanol')=cellethSUPPLY.L('t11')/1000;

*calibrate('VMT production')=   sum(vehicle,endvmt('t1',vehicle))/1000;
calibrate('cwc credit')= EndFuel('t11','cellwaiver')/1000 ;
calibrate('BBD over')= RFS_RMANDATE2_bbd.l('t11')/1000;
calibrate('biofuel over')=  RFS_RMANDATE2.l('t11')/1000;
*calibrate('D3RIN stocks 2010')= EndFuel('t4','stock_D3');
*calibrate('D4RIN stocks 2010')= EndFuel('t4','stock_D4') ;
*calibrate('D6RIN stocks 2010')= EndFuel('t4','stock_D6');
*calibrate('DSL VMT')=DSLMILECONS.L('T1');

set rin_eth(rin) /D3,D6/;
parameter A(t), B(t),Pass(t,*),Passthrough(t),blendwall(t,*);
A(t)=blendw(T,'E85')/energycoefeth(t,'E85')-blendw(T,'E10')/energycoefeth(t,'E10');
B(t)=(1-blendw(T,'E85'))/energycoefeth(t,'E85')-(1-blendw(T,'E10'))/energycoefeth(t,'E10');

Pass(t,'eth_pro')=-(cellethsupply_weigh.m(t)*cellEthsupply.l(t)+(ethsupply_weigh.m(t)+0.45$(ord(t) le 5)-cornlimit.m(t))* Ethsupply.l(t))/(Ethsupply.l(t)+cellEthsupply.l(t));

Passthrough(t)= (A(t)*instruments_fuel(t,'Ethanol_pergal')+B(t)*instruments_fuel(t,'gas_pergal'))/(A(t)*Pass(t,'eth_pro')+B(t)*Gas_prod.m(t)+blendcost('E85')/energycoefeth(t,'E85')-blendcost('E10')/energycoefeth(t,'E10'));

blendwall(t,'biofuel')= sum(rin,DCODE.l(T,rin))/( EndFuel(t,'DIESEL')+EndFuel(t,'gas'));
blendwall(t,'blendw')=0.1/0.9*EndFuel(t,'gas')/( EndFuel(t,'DIESEL')+EndFuel(t,'gas'));
blendwall(t,'blend_ethanol')=sum(rin_eth,DCODE.l(T,rin_eth))/( EndFuel(t,'DIESEL')+EndFuel(t,'gas')) ;
blendwall(t,'test')= A(t)*Eth_BALANCE.m(T)+B(t)*GAS_BALANCE.m(t)+blendcost('E85')/energycoefeth(t,'E85')-blendcost('E10')/energycoefeth(t,'E10')   ;
blendwall(t,'denominator')= A(t)*Pass(t,'eth_pro')+B(t)*Gas_prod.m(t)+blendcost('E85')/energycoefeth(t,'E85')-blendcost('E10')/energycoefeth(t,'E10') ;
blendwall(t,'blendingcost')=blendcost('E85')/energycoefeth(t,'E85')-blendcost('E10')/energycoefeth(t,'E10') ;
blendwall(t,'nominator')= A(t)*instruments_fuel(t,'Ethanol_pergal')+B(t)*instruments_fuel(t,'gas_pergal') ;
blendwall(t,'blending diff')=  blendcost('E85')/energycoefeth(t,'E85')-blendcost('E10')/energycoefeth(t,'E10');
*$OFFTEXT
$ONTEXT
Instrument_out('cv_yearlyavg')=sum((t2,age2),Instrument(T2,'CV_TAX',AGE2))/card(t2)/card(age2);
Instrument_out('cv_onetimepayavg')=max(smax(age2, Vinstrument('condition1','cvs',age2)), smax(t2, Vinstrument('condition2','cvs',t2)));
Instrument_out('cv_percentage')= Instrument_out('cv_onetimepayavg')/IC('cvs');
Instrument_out('ffv_yearlyavg')=sum((t2,age2),Instrument(T2,'FFV_SUB',AGE2))/card(t2)/card(age2);
Instrument_out('ffv_onetimepayavg')=min(smin(age2, Vinstrument('condition1','ffv',age2)), smin(t2, Vinstrument('condition2','ffv',t2)));
Instrument_out('ffv_percentage')= Instrument_out('ffv_onetimepayavg')/IC('ffv');

*Enprice(t2,'FFV_fuel_gge','cons')= (EnPrice(t2,'e10_gge',"cons")*EndE10(t2,'ffv')*alpha(t2)+EnPrice(t2,'eth_gge',"cons")*EndEth(t2,"E_xr")*2/3)/(EndE10(t2,'ffv')*alpha(t2)+EndEth(t2,"E_xr")*2/3);
parameter LifeAnalysis(*,*,*,t,*);
parameter Reg(age);
Reg(age)=1071;

LifeAnalysis("Marginal",vehicle2,'VMT benefit',t,age)$(ord(age)=1)= Sum(T2$(ord(T2)ge ord(t) and ord(T2)le 34 ),(1/(1+disc))**(ORD(T2)-Ord(T))* (avgVMT2(vehicle2,age+(ORD(T2)-Ord(T)))* ENPrice(t2,'Mile','cons')));
LifeAnalysis("Marginal",vehicle2,'Termval',t,age)$(ord(age)=1)= (1/(1+disc))**(card(t2)-ord(t))*0.8*IC(vehicle2)*Depr(age+(34-ord(t)));
LifeAnalysis("Marginal",vehicle2,'InitalCost',t,age)$(ord(age)=1)=  IC(vehicle2) ;
LifeAnalysis("Marginal",'cvs','Fuelcost',t,age)$(ord(age)=1)=Sum(T2$(ord(T2)ge ord(t) and ord(T2)le 34 ),(1/(1+disc))**(ORD(T2)-Ord(T))* (avgVMT2('cvs',age+(ORD(T2)-Ord(T)))*EnPrice(t2,'e10_gge',"cons")/MILEAGE2(t,'cvs','age1')));
LifeAnalysis("Marginal",'ffv','Fuelcost',t,age)$(ord(age)=1)=Sum(T2$(ord(T2)ge ord(t) and ord(T2)le 34 ),(1/(1+disc))**(ORD(T2)-Ord(T))* (avgVMT2('ffv',age+(ORD(T2)-Ord(T)))*Enprice(t2,'FFV_fuel_gge','cons')/MILEAGE2(t,'ffv','age1')));
LifeAnalysis("Marginal",'cvs','tax',t,age)$(ord(age)=1)= Sum(T2$(ord(T2)ge ord(t) and ord(T2)le 34 ),(1/(1+disc))**(ORD(T2)-Ord(T))* (avgVMT2('cvs',age+(ORD(T2)-Ord(T)))*Instrument(t2,'tax_E10_gge','')/MILEAGE2(t,'cvs','age1')));
LifeAnalysis("Marginal",'ffv','subsidy',t,age)$(ord(age)=1)= Sum(T2$(ord(T2)ge ord(t) and ord(T2)le 34 ),(1/(1+disc))**(ORD(T2)-Ord(T))* (avgVMT2('ffv',age+(ORD(T2)-Ord(T)))*Instrument(t2,'Sub_ETH_gge','')/MILEAGE2(t,'ffv','age1')));

LifeAnalysis("Marginal",vehicle2,'Marginal O&M',t,age)$(ord(age)=1)=Sum(T2$(ord(T2)ge ord(t) and ord(T2)le 34 ),(1/(1+disc))**(ORD(T2)-Ord(T))* (Reg(age+(Ord(T2)-ORD(T)))+avgVMT2(vehicle2,age+(Ord(T2)-ORD(T)))* VC(vehicle2)));
LifeAnalysis("Marginal",vehicle2,'Marginal NetFOC',t2,age)=LifeAnalysis("Marginal",vehicle2,'VMT benefit',t2,age)+ LifeAnalysis("Marginal",vehicle2,'Termval',t2,age)
                                    -LifeAnalysis("Marginal",vehicle2,'InitalCost',t2,age)- LifeAnalysis("Marginal",vehicle2,'Fuelcost',t2,age)- LifeAnalysis("Marginal",vehicle2,'Marginal O&M',t2,age);
LifeAnalysis("Marginal","ffv",'FFVsubsidy for FFV',t,age)$(ord(age)=1)= Sum(T2$(ord(T2)ge ord(t) and ord(T2)le 34 ),(1/(1+disc))**(ORD(T2)-Ord(T))* (avgVMT2('ffv',age+(ORD(T2)-Ord(T)))*(EnPrice(t2,'e10_gge',"cons")-Enprice(t2,'FFV_fuel_gge','cons'))/MILEAGE2(t,'ffv','age1')));

LifeAnalysis("Total",vehicle2,'VMT benefit',t,'')= LifeAnalysis("Marginal",vehicle2,'VMT benefit',t,'age1')*EndNewv(t,vehicle2);
LifeAnalysis("Total",vehicle2,'Termval',t,'')=  LifeAnalysis("Marginal",vehicle2,'Termval',t,'age1')*EndNewv(t,vehicle2);
LifeAnalysis("Total",vehicle2,'InitalCost',t,'')= LifeAnalysis("Marginal",vehicle2,'InitalCost',t,'age1')*EndNewv(t,vehicle2);
LifeAnalysis("Total",vehicle2,'Fuelcost',t,'')=  LifeAnalysis("Marginal",vehicle2,'Fuelcost',t,'age1') *EndNewv(t,vehicle2);
LifeAnalysis("Total",vehicle2,'O&M',t,'')=  LifeAnalysis("Marginal",vehicle2,'Marginal O&M',t,'age1') *EndNewv(t,vehicle2);
LifeAnalysis("Total",vehicle2,'NetB',t,'')= LifeAnalysis("Total",vehicle2,'VMT benefit',t,'')+LifeAnalysis("Total",vehicle2,'Termval',t,'')-LifeAnalysis("Total",vehicle2,'InitalCost',t,'')-LifeAnalysis("Total",vehicle2,'Fuelcost',t,'')-LifeAnalysis("Total",vehicle2,'O&M',t,'');

Instrument_out('cv_yearlyavg')=sum((t2,age2),Instrument(T2,'CV_TAX',AGE2))/card(t2)/card(age2);
Instrument_out('cv_onetimepayavg_max')= smax(t2,LifeAnalysis("Marginal",'cvs','tax',t2,'age1'));
Instrument_out('cv_onetimepayavg_min')= smin(t2,LifeAnalysis("Marginal",'cvs','tax',t2,'age1'));
Instrument_out('cv_percentage_max')= Instrument_out('cv_onetimepayavg_max')/IC('cvs');
Instrument_out('cv_percentage_min')= Instrument_out('cv_onetimepayavg_min')/IC('cvs');
Instrument_out('ffv_yearlyavg')=sum((t2,age2),Instrument(T2,'FFV_SUB',AGE2))/card(t2)/card(age2);
Instrument_out('ffv_onetimepayavg_max')= smin(t2, LifeAnalysis("Marginal",'ffv','subsidy',t2,'age1'));
Instrument_out('ffv_onetimepayavg_min')= smax(t2, LifeAnalysis("Marginal",'ffv','subsidy',t2,'age1'));
Instrument_out('ffv_percentage_max')= Instrument_out('ffv_onetimepayavg_max')/IC('ffv');
Instrument_out('ffv_percentage_min')= Instrument_out('ffv_onetimepayavg_min')/IC('ffv');


LifeAnalysis("Total",vehicle2,'VMT benefit',t,'')=  (1/(1+disc))**(Ord(T)-1)* (
                 sum((age),VMTs.l(vehicle2,age,T))*(MileA2(t) - 0.5*MileB*sum((age),VMTs.l(vehicle2,age,T)))-sum((age),VMTs.l(vehicle2,age,T))*MILEPRODC.m(T)
                 );
LifeAnalysis("Total",vehicle2,'Termval',t,'')= (1/(1+disc))**(card(t2)-ord(t))*0.8*IC(vehicle2)*Depr(age+(34-ord(t)))*EndNewv(t,vehicle2);
LifeAnalysis("Total",vehicle2,'InitalCost',t,'')= (1/(1+disc))**(Ord(T)-1)* ( IC(vehicle2)* NEWVEHICLE.l(vehicle2,t))) ;


*LifeAnalysis('','FFV sub',t2,'')$(EndNewv(t2,'cvs') and EndNewv(t2,'ffv'))= LifeAnalysis('CVs','Total NetBenefit',t2,'age1')/EndNewv(t2,'cvs') -LifeAnalysis('ffv','Total NetBenefit',t2,'age1')/EndNewv(t2,'ffv');



parameter output (*,*);
****target year 2022
output("Blend rate in %",'2022')= endeth('t16','total')/(endeth('t16','total')+EndFuel('t16','gas'));
output("E10 tax $/gge",'2022')= EnPrice('t16','E10_gge',"cons")-EnPrice('t16','E10_gge',"PRO");
output("E100 subsidy,total $/gge",'2022')= EnPrice('t16','eth_gge',"cons")-EnPrice('t16','eth_gge',"PRO");
output("E100 subsidy,Fsub $/gge",'2022')= -EnPrice('t16','eth_gge',"pro")+EnPrice('t16','E10_gge',"cons");
output("E100 subsidy,Vsub $/gge",'2022')= -EnPrice('t16','E10_gge',"cons")+EnPrice('t16','eth_gge',"cons");
output("Preblended fuel, fuel consumption",'2022')= EndFuel('t16','E10')*EnergycoefEth('t16','e10')/1000;
output("blended gas, fuel consumption",'2022')= EndFuel('t16','gas')/1000;
output("blended ethanol, fuel consumption",'2022')= endeth('t16','B_E')*2/3/1000;
output("E100, fuel consumption",'2022')= endeth('t16','E_xr')*2/3/1000;
output('Total fuel use,gge','2022')=  output("Preblended fuel, fuel consumption",'2022')+ output("E100, fuel consumption",'2022');
output('E10,Fuel consumer price,$/gge','2022')= EnPrice('t16','E10_gge',"cons");
output('ETH,Fuel consumer price,$/gge','2022')= EnPrice('t16','ETH_gge',"cons");
output('gas,Fuel consumer price,$/gge','2022')= EnPrice('t16','E10_gge',"cons")+(EnPrice('t16','E10_gge',"cons")-EnPrice('t16','ETH_gge',"cons"))/9*2/3;

output('CV tax','2022')= LifeAnalysis("Marginal",'cvs','tax','t16','age1');
output('FFV sub, total','2022')=LifeAnalysis("Marginal",'ffv','subsidy','t16','age1');
output('FFV Vsub, total','2022')=-LifeAnalysis("Marginal","ffv",'FFVsubsidy for FFV','t16','age1');
output('FFV Fsub, total','2022')= output('FFV sub, total','2022')-output('FFV Vsub, total','2022');


output('CV,Vehicle stock structure in million','2022')= EndNewstock('t16','cvs');
output('ffv,Vehicle stock structure in million','2022')= EndNewstock('t16','ffv');
output('CV,VMT in billion mi','2022')= EndVMT('t16','CVS')/1000;
output('FFV,VMT in billion mi','2022')= EndVMT('t16','FFV')/1000;
output('total,VMT in billion mi','2022')= sum(vehicle, EndVMT('t16',vehicle))/1000;

****2040
output("Blend rate in %",'2040')= endeth('t34','total')/(endeth('t34','total')+EndFuel('t34','gas'));
output("E10 tax $/gge",'2040')= EnPrice('t34','E10_gge',"cons")-EnPrice('t34','E10_gge',"PRO");
output("E100 subsidy,total $/gge",'2040')= EnPrice('t34','eth_gge',"cons")-EnPrice('t34','eth_gge',"PRO");
output("E100 subsidy,Fsub $/gge",'2040')= -EnPrice('t34','eth_gge',"pro")+EnPrice('t34','E10_gge',"cons");
output("E100 subsidy,Vsub $/gge",'2040')= -EnPrice('t34','E10_gge',"cons")+EnPrice('t34','eth_gge',"cons");
output("Preblended fuel, fuel consumption",'2040')= EndFuel('t34','E10')*alpha('t34')/1000;
output("blended gas, fuel consumption",'2040')= EndFuel('t34','gas')/1000;
output("blended ethanol, fuel consumption",'2040')= endeth('t34','B_E')*2/3/1000;
output("E100, fuel consumption",'2040')= endeth('t34','E_xr')*2/3/1000;
output('Total fuel use,gge','2040')=  output("Preblended fuel, fuel consumption",'2022')+ output("E100, fuel consumption",'2022');
output('E10,Fuel consumer price,$/gge','2040')= EnPrice('t34','E10_gge',"cons");
output('ETH,Fuel consumer price,$/gge','2040')= EnPrice('t34','ETH_gge',"cons");
output('gas,Fuel consumer price,$/gge','2040')= EnPrice('t34','E10_gge',"cons")+(EnPrice('t34','E10_gge',"cons")-EnPrice('t34','ETH_gge',"cons"))/9*2/3;

output('CV tax','2040')= LifeAnalysis("Marginal",'cvs','tax','t34','age1');
output('FFV sub, total','2040')=LifeAnalysis("Marginal",'ffv','subsidy','t34','age1');
output('FFV Vsub, total','2040')=-LifeAnalysis("Marginal","ffv",'FFVsubsidy for FFV','t34','age1');
output('FFV Fsub, total','2040')= output('FFV sub, total','2022')-output('FFV Vsub, total','2022');


output('CV,Vehicle stock structure in million','2040')= EndNewstock('t34','cvs');
output('ffv,Vehicle stock structure in million','2040')= EndNewstock('t34','ffv');
output('CV,VMT in billion mi','2040')= EndVMT('t34','CVS')/1000;
output('FFV,VMT in billion mi','2040')= EndVMT('t34','FFV')/1000;
output('total,VMT in billion mi','2040')= sum(vehicle, EndVMT('t34',vehicle))/1000;



$offtext
parameter OutputInterest(*);
OutputInterest('Cellulosic Ethanol')=EndFuel('t11','cell');
OutputInterest('Cellulosic waiver')=EndFuel('t11','cellwaiver');
OutputInterest('Corn ethanol')=EndFuel('t11','corneth');
OutputInterest('Biodiesel use')=EndFuel('t11','BBD');
OutputInterest('BBD overage')=RFS_RMANDATE2_bbd.l('t11');
OutputInterest('Gasoline use')=EndFuel('t11','gas');
OutputInterest('Diesel use')=EndFuel('t11','Diesel');
OutputInterest('E10 use')=EndFuel('t11','E10');
OutputInterest('E85 use')=EndFuel('t11','E85');
OutputInterest('RIN PRICE_D3')=EnPrice('t11','D3',"PRO");
OutputInterest('RIN PRICE_D4')=EnPrice('t11','D4',"PRO");
OutputInterest('RIN PRICE_D6')=EnPrice('t11','D6',"PRO");
OutputInterest('E85 retail')=ENPrice('t11','E85_gge',"cons") ;
OutputInterest('E10 retail')=ENPrice('t11','E10_gge',"cons");
OutputInterest('DF retail')=ENPrice('t11','DIESEL',"cons");
OutputInterest('Pricediff_E85-E10')= OutputInterest('E85 retail')-OutputInterest('E10 retail');
OutputInterest('Passthrough')=Passthrough('t11');

$include GHG.gms

execute_unload  'static042319_nested_cellwaiver_GHG.gdx' ;


