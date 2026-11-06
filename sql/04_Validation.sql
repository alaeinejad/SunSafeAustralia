USE SunSafeAustraliaDW;
GO
-- Expected: 258 initial, 1347 extended, 1605 unified.
SELECT COUNT(*) AS InitialRows FROM stg.ABSProtectionInitial;
SELECT COUNT(*) AS ExtendedRows FROM stg.ABSProtectionExtended;
SELECT COUNT(*) AS ReportingRows FROM rpt.vwSunProtection;
-- Expected by table: 129,129,129,696,522.
SELECT TableNumber, COUNT(*) AS RowsPerTable
FROM rpt.vwSunProtection GROUP BY TableNumber ORDER BY TableNumber;
-- Must return zero rows.
SELECT SurveyPeriod,TableNumber,Metric,Breakdown,Category,Sex,COUNT(*) AS DuplicateRows
FROM rpt.vwSunProtection
GROUP BY SurveyPeriod,TableNumber,Metric,Breakdown,Category,Sex HAVING COUNT(*)>1;
-- Review source national estimates and their published margins.
SELECT TableNumber,Metric,Sex,EstimateUnit,ProportionPercent,MarginOfError95PP
FROM rpt.vwSunProtection WHERE Breakdown=N'National total'
ORDER BY TableNumber,Metric,Sex;
