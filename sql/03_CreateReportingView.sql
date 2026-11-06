USE [SunSafeAustraliaDW]
GO

-- Unified reporting view for ABS Tables 1–5.
IF SCHEMA_ID(N'rpt') IS NULL EXEC(N'CREATE SCHEMA rpt');
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW [rpt].[vwSunProtection]
AS
SELECT
    SurveyPeriod,
    SourceFile,
    CAST(
        CASE
            WHEN Topic = N'Routine sunscreen SPF30+' THEN 1
            WHEN Topic = N'Sunburn last week' THEN 2
        END AS tinyint
    ) AS TableNumber,
    Topic AS Metric,
    Breakdown,
    Category,
    Sex,
    CAST(N'All persons aged 15+' AS nvarchar(100)) AS Population,
    CAST('thousand persons' AS varchar(20)) AS EstimateUnit,
    EstimateThousands AS EstimateValue,
    EstimateRSEPercent,
    ProportionPercent,
    MarginOfError95PP,
    CAST(
        CASE
            WHEN MarginOfError95PP IS NULL THEN 'Missing in source'
            ELSE 'Available'
        END AS varchar(30)
    ) AS ProportionErrorStatus,
    EstimateSheet,
    EstimateCell,
    RSECell,
    ProportionSheet,
    ProportionCell,
    MOECell
FROM stg.ABSProtectionInitial

UNION ALL

SELECT
    SurveyPeriod,
    SourceFile,
    TableNumber,
    Metric,
    Breakdown,
    Category,
    Sex,
    Population,
    EstimateUnit,
    EstimateValue,
    EstimateRSEPercent,
    ProportionPercent,
    MarginOfError95PP,
    ProportionErrorStatus,
    EstimateSheet,
    EstimateCell,
    RSECell,
    ProportionSheet,
    ProportionCell,
    MOECell
FROM stg.ABSProtectionExtended;
GO


