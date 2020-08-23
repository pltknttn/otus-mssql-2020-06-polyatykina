﻿SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;
 
USE WideWorldImporters 
GO

PRINT N'Creating [StringExpressions]...'; 
GO

CREATE ASSEMBLY [StringExpressions]
    AUTHORIZATION [dbo]
    FROM 0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000800000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000504500004C01030042D3425F0000000000000000E00022200B0130000016000000060000000000008E3400000020000000400000000000100020000000020000040000000000000006000000000000000080000000020000000000000300608500001000001000000000100000100000000000001000000000000000000000003C3400004F00000000400000C802000000000000000000000000000000000000006000000C000000043300001C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000080000000000000000000000082000004800000000000000000000002E7465787400000094140000002000000016000000020000000000000000000000000000200000602E72737263000000C8020000004000000004000000180000000000000000000000000000400000402E72656C6F6300000C0000000060000000020000001C0000000000000000000000000000400000420000000000000000000000000000000070340000000000004800000002000500B0240000540E00000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000133002001800000001000011000F00280E00000A036F0F00000A73060000060A2B00062A133002002B00000002000011000274030000020A03066F03000006731000000A810A00000104066F04000006731100000A81080000012A00133001000C0000000300001100027B010000040A2B00062A133001000C0000000400001100027B020000040A2B00062A5E02281200000A000002037D0100000402047D020000042A5E02281200000A000002047D0300000402037D040000042A3A16730F00000625027D0A0000042A7E000272010000707D0600000402167D0500000402731300000A7D070000042A0013300300970000000500001173150000060A06037D10000004000F02281400000A16FE010B072C0D020F02280E00000A7D060000040F03281500000A16FE010C082C0D020F03281600000A7D05000004067C10000004281400000A0D092C022B41027B050000042C19027B0700000406FE0616000006731700000A6F1800000A2B0116130411042C022B17027B07000004067C10000004280E00000A6F1900000A002A001B300300B80000000600001100037B07000004252D0426162B08281A00000A16FE020A06399A00000000037B06000004281B00000A16FE010B072C0C02037B060000047D0600000400037B070000046F1C00000A0C2B5173170000060D091202281D00000A7D1100000400027B050000042C19027B0700000409FE0618000006731700000A6F1800000A2B0116130411042C022B13027B07000004097B110000046F1900000A00001202281E00000A2DA6DE0F1202FE160400001B6F0700000A00DC002A01100000020049005EA7000F00000000133002004300000007000011007E1F00000A0A027B070000042C10027B070000046F1A00000A16FE022B01160B072C1400027B06000004027B07000004282000000A0A0006731100000A0C2B00082A001330050056000000080000110002731300000A7D070000040314FE010B072C022B3F036F2100000A252D0426142B15178D1B0000012516027B06000004A217282200000A0A062D03162B05068E16FE030C082C0D027B07000004066F2300000A002A6A0003027B06000004027B07000004282000000A6F2400000A002A2202281200000A002A3E02281200000A0002037D080000042A062A13300400D700000009000011027B080000040A062C082B0006172E042B072B073888000000162A02157D080000040002167D0B00000402027B0A0000047B04000004027B0A0000047B03000004176F2500000A7D0C0000040002027B0C0000047D0D00000402167D0E0000042B5C02027B0D000004027B0E0000049A7D0F0000040002027B0B00000417580B02077D0B00000407027B0F00000473050000067D0900000402177D08000004172A02157D080000040002147D0F00000402027B0E00000417587D0E000004027B0E000004027B0D0000048E69329402147D0D000004162A1E027B090000042A1A732600000A7A4A03027C10000004280E00000A282700000A2A3603027B11000004282700000A2A0042534A4201000100000000000C00000076342E302E33303331390000000005006C000000C0050000237E00002C060000C805000023537472696E677300000000F40B00000800000023555300FC0B00001000000023475549440000000C0C00004802000023426C6F6200000000000000020000015717A20B0902000000FA013300160000010000001E0000000800000011000000180000001200000005000000270000000E0000000900000002000000040000000400000005000000040000000100000002000000030000000000C30201000000000006003C029C0306005C029C030600BC0189030F00BC03000006004E04E4020A0027023C030600430105040A00B902CB030A002B04CB030A008300CB0306005B01E4020600D0019C030600570305040600A1019C0306004F01E40206006E00F30006000F0289030A0047043C030A00EE013C030A0093023C0306007C00F3000A00EB02CB0357006603000006001703CF0006002F03CF0006006200E4020600BC02E40206005400F30006001804E4020600FB02E40200000000C6000000000001000100810110009605F303150001000100000010002A01F303150001000300000010007103F30315000300060001201000A402F303150005000800030110009A000000150008000F00030110000100000015001000150003011000160000001500110017000100AC05EA0001008402A60001003404ED0001007405A60001008B02F10001002403A6000100E003F40001009001EA0001005D05FB000600E903FE0001004800EA0001008C0002010100AE0002010100B500EA000100BC00A60006008502060106008503A60050200000000096007A040A0101007420000000009600890513010300AC20000000008608A20587000600C4200000000086087A0234000600DC200000000086187F031E010600F4200000000086187F03240108000C2100000000E60163032B010A001B21000000008600860406000A003C210000000086007B0130010A00E0210000000086003D013A010D00B422000000008600860140010E00042300000000E6010E0145010E00662300000000E6019B014B010F0081230000000086187F03060010008A230000000086187F03010010009A2300000000E1016001060011009C2300000000E1017B05160011007F2400000000E109F00425001100872400000000E1015504060011007F2400000000E10932052500110081230000000086187F03060011008E2400000000830037005101110081230000000086187F0306001200A1240000000083002B005101120000000100850200000200350400000100E50002000200AD0502000300840500000100AD05000002008502000001007505000002003504000001008502000002002503000003008C0200000100110300000100870300000100940500000100900100000100B10500000100B10504001D00050051000600060006003D000600350009007F03010011007F03060019007F030A0031007F03060061007F03100071007F03060079007301060069007B0516000C005105200069007404060069005105250089007F03060099007F03290041007A02340049007A02380051007F03010041007F03420029007F03060014007F0306004100D9021600B100D9021600B1007A0216001C007F036400140040046A0014001301740014006A058700D90017018B0014006303900024005105200024007B051600D900BF05A600D900F602A900C100AE023400D9008004BA0014003401C300C9009B014200D9008004D200F1007F030600D900B305DB002000230093012E000B0062012E0013006B012E001B008A01A3006B002A02C30033002502E0002B00EC01E30033002502030133002502E001630025020002630025024002630025026002630025028002630025022F003D0047004B0055007A009F00B300CD0003000100060003000000A605560100007E025A0100008B045E010000C9045E01020003000300020004000500020012000700020014000900060020000F000600220011000600240013000600260015000600280017001A004F005E009900048000000000000000000000000000000000F3030000040000000000000000000000E100EA0000000000040000000000000000000000E100D9000000000006000400070005000800050000000000003C3E635F5F446973706C6179436C617373345F30003C3E635F5F446973706C6179436C617373355F30003C4D657267653E625F5F30003C416363756D756C6174653E625F5F30003C696E6465783E355F5F310049456E756D657261626C6560310050726564696361746560310049456E756D657261746F726031004C69737460310053716C496E743332003C726573756C74733E355F5F32003C476574456E756D657261746F723E645F5F33003C3E735F5F33003C3E735F5F34003C7374723E355F5F35003C4D6F64756C653E0053797374656D2E494F0053797374656D2E446174610064617461006D73636F726C69620053797374656D2E436F6C6C656374696F6E732E47656E657269630052656164004164640049734E756C6C4F72576869746553706163650053706C69744E6F64650041646452616E6765004D657267650049456E756D657261626C650049446973706F7361626C6500547970650053797374656D2E49446973706F7361626C652E446973706F736500416363756D756C617465005465726D696E617465003C3E315F5F737461746500577269746500436F6D70696C657247656E6572617465644174747269627574650044656275676761626C65417474726962757465004974657261746F7253746174654D616368696E654174747269627574650053716C55736572446566696E656441676772656761746541747472696275746500446562756767657248696464656E4174747269627574650053716C46756E6374696F6E41747472696275746500436F6D70696C6174696F6E52656C61786174696F6E734174747269627574650052756E74696D65436F6D7061746962696C697479417474726962757465006765745F56616C7565005F76616C7565005F756E69717565004942696E61727953657269616C697A6500537472696E674167670052656164537472696E670053716C537472696E6700537472696E6745787072657373696F6E732E646C6C006765745F49734E756C6C0053797374656D0053716C426F6F6C65616E004A6F696E004E6F74537570706F72746564457863657074696F6E0067726F75700042696E617279526561646572005F64656C696D657465720042696E617279577269746572004D6963726F736F66742E53716C5365727665722E5365727665720049456E756D657261746F7200476574456E756D657261746F720053706C69744974657261746F72002E63746F72007374720053797374656D2E446961676E6F73746963730053797374656D2E52756E74696D652E436F6D70696C6572536572766963657300446562756767696E674D6F6465730053797374656D2E446174612E53716C5479706573005F737472696E6773003C3E345F5F7468697300537472696E6745787072657373696F6E730053797374656D2E436F6C6C656374696F6E7300537472696E6753706C69744F7074696F6E730053716C4368617273005F64656C696D65746572730045786973747300466F726D6174004F626A6563740053797374656D2E436F6C6C656374696F6E732E49456E756D657261746F722E526573657400537472696E6753706C697400496E69740053797374656D2E436F6C6C656374696F6E732E47656E657269632E49456E756D657261746F723C53797374656D2E4F626A6563743E2E43757272656E740053797374656D2E436F6C6C656374696F6E732E49456E756D657261746F722E43757272656E740053797374656D2E436F6C6C656374696F6E732E47656E657269632E49456E756D657261746F723C53797374656D2E4F626A6563743E2E6765745F43757272656E740053797374656D2E436F6C6C656374696F6E732E49456E756D657261746F722E6765745F43757272656E74003C3E325F5F63757272656E74006765745F436F756E74005F696E707574004D6F76654E65787400746578740046696C6C53706C6974526F770053716C537472696E674578006765745F496E646578005F696E646578006F705F457175616C69747900456D7074790000000000033B0000000000B7880F7E4C87AC49939CAEA6C599C6FA0004200101080320000105200101111105200101122D0320000205151241011C04200013000320001C052001011149040701121D0320000E0420001D03040701120C042001010E030701080307010E05151255010E080705121C0202020205151269010E052002011C18092001021512690113000520010113000C0705020215115D010E12200203200008040001020E08200015115D0113000515115D010E0607030E02112102060E0900020E0E151271010E0607031D0E02020820021D0E1D0E11750920010115127101130004070208080820021D0E1D031175050002020E0E08B77A5C561934E08902060803061D030206020606151255010E02061C0306121003061D0E03061121080002121D112112250A0003011C10112910112105200201080E062002010E1D030420001235092003011121112111590520010112140420001121052001011261052001011265042001020E032800080328000E0328001C0801000800000000001E01000100540216577261704E6F6E457863657074696F6E5468726F7773010801000701000000005801000200540E1146696C6C526F774D6574686F644E616D650C46696C6C53706C6974526F77540E0F5461626C65446566696E6974696F6E205B496E6465785D20696E742C5B546578745D206E76617263686172286D61782938010033537472696E6745787072657373696F6E732E53706C69744974657261746F722B3C476574456E756D657261746F723E645F5F33000004010000001A010002000000010054080B4D61784279746553697A65401F00000000000000000042D3425F00000000020000001C01000020330000201500005253445340D9BC190EF639418AD0D3CAAC757DA701000000443A5C576F726B696E675C4769745265706F7369746F72795C4F7475735C6F7475732D6D7373716C2D323032302D30362D706F6C796174796B696E615C48573133202D2073702C66756E635C43535C526567756C617245787072657373696F6E735C537472696E6745787072657373696F6E735C6F626A5C44656275675C537472696E6745787072657373696F6E732E70646200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006434000000000000000000007E34000000200000000000000000000000000000000000000000000070340000000000000000000000005F436F72446C6C4D61696E006D73636F7265652E646C6C0000000000FF250020001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001001000000018000080000000000000000000000000000001000100000030000080000000000000000000000000000001000000000048000000584000006C02000000000000000000006C0234000000560053005F00560045005200530049004F004E005F0049004E0046004F0000000000BD04EFFE00000100000000000000000000000000000000003F000000000000000400000002000000000000000000000000000000440000000100560061007200460069006C00650049006E0066006F00000000002400040000005400720061006E0073006C006100740069006F006E00000000000000B004CC010000010053007400720069006E006700460069006C00650049006E0066006F000000A801000001003000300030003000300034006200300000002C0002000100460069006C0065004400650073006300720069007000740069006F006E000000000020000000300008000100460069006C006500560065007200730069006F006E000000000030002E0030002E0030002E00300000004C001600010049006E007400650072006E0061006C004E0061006D006500000053007400720069006E006700450078007000720065007300730069006F006E0073002E0064006C006C0000002800020001004C006500670061006C0043006F0070007900720069006700680074000000200000005400160001004F0072006900670069006E0061006C00460069006C0065006E0061006D006500000053007400720069006E006700450078007000720065007300730069006F006E0073002E0064006C006C000000340008000100500072006F006400750063007400560065007200730069006F006E00000030002E0030002E0030002E003000000038000800010041007300730065006D0062006C0079002000560065007200730069006F006E00000030002E0030002E0030002E003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000C000000903400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

GO 

PRINT N'Creating [dbo].[StringAgg]...'; 

GO
CREATE AGGREGATE [dbo].[StringAgg](@value NVARCHAR (MAX) NULL, @delimeter NVARCHAR (MAX) NULL, @unique BIT NULL)
    RETURNS NVARCHAR (MAX)
    EXTERNAL NAME [StringExpressions].[StringExpressions.StringAgg];

PRINT N'Creating [dbo].[StringSplit]...';
 
GO
CREATE FUNCTION [dbo].[StringSplit]
(@value NVARCHAR (MAX) NULL, @delimeters NVARCHAR (MAX) NULL)
RETURNS 
     TABLE (
        [Index] INT            NULL,
        [Text]  NVARCHAR (MAX) NULL)
AS
 EXTERNAL NAME [StringExpressions].[StringExpressions.SqlStringEx].[StringSplit]


GO
PRINT N'Update complete.';


GO