USE [master]
GO

Admin_ETL_DataExtractor
65eBUThApbsLYrcBdR7QkREXtHUQTsLw

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [Admin_ETL_DataExtraction]    Script Date: 30/12/2021 17:09:41 ******/
CREATE LOGIN [Admin_ETL_DataExtraction] WITH PASSWORD=N'fYaPEYtwpZl283S/ZpW5OaQmUEAVONPQtjZUW6x2jQE=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [Admin_ETL_DataExtraction] ENABLE
GO

Use DecisionEngine;
sp_change_users_login UPDATE_ONE, 'Admin_ETL_DataExtraction', 'Admin_ETL_DataExtraction'


Use DecisionEngine_Preprocessor;
sp_change_users_login UPDATE_ONE, 'Admin_ETL_DataExtraction', 'Admin_ETL_DataExtraction'



USE [ETL_DataExtraction]
GO
sp_change_users_login UPDATE_ONE, 'Admin_ETL_DataExtraction', 'Admin_ETL_DataExtraction'


/****** Object:  DatabaseRole [ETL_DataExtraction_Role]    Script Date: 30/12/2021 17:10:18 ******/
CREATE ROLE [ETL_DataExtraction_Role]
GO

USE [ETL_DataExtraction]
GO

/****** Object:  User [Admin_ETL_DataExtraction]    Script Date: 30/12/2021 17:10:38 ******/
CREATE USER [Admin_ETL_DataExtraction] FOR LOGIN [Admin_ETL_DataExtraction] WITH DEFAULT_SCHEMA=[dbo]
GO


USE [DecisionEngine]
GO
ALTER ROLE [ETL_DataExtraction_Role] ADD MEMBER [Admin_ETL_DataExtraction]
GO

USE [DecisionEngine]
GO
CREATE USER [Admin_ETL_DataExtraction] FOR LOGIN [Admin_ETL_DataExtraction]
GO
USE [DecisionEngine]
GO
ALTER USER [Admin_ETL_DataExtraction] WITH DEFAULT_SCHEMA=[dbo]
GO
USE [DecisionEngine]
GO
ALTER ROLE [ETL_DataExtraction] ADD MEMBER [Admin_ETL_DataExtraction]
GO


EXEC SP_CHANGE_USERS_LOGIN REPORT
