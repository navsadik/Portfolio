-- SP1
CREATE PROCEDURE dbo.StoredProcedure1
AS
BEGIN
    SELECT
        c.*,
        fs.*
    FROM
        [DimCustomer] c
    LEFT JOIN
        [FactSales] fs ON c.[CustomerKey] = fs.[CustomerKey];
END
GO

-- SP2
CREATE PROCEDURE dbo.StoredProcedure2
AS
BEGIN
    SELECT
        YEAR([OrderDate]) AS SalesYear,
        ROUND(SUM([SalesAmount]),2) AS TotalSales
    FROM
        [FactSales]
    GROUP BY
        YEAR([OrderDate])
    ORDER BY
        SalesYear;
END
GO

-- SP3
CREATE PROCEDURE dbo.StoredProcedure3
AS
BEGIN
    SELECT TOP 10
        c.[FirstName],
        c.[LastName],
        ROUND(SUM(fs.[SalesAmount]), 2) AS TotalSales
    FROM
        [FactSales] fs
    INNER JOIN
        [DimCustomer] c ON fs.[CustomerKey] = c.[CustomerKey]
    GROUP BY
        c.[FirstName], c.[LastName]
    ORDER BY
        TotalSales DESC;
END
GO

-- SP4
CREATE PROCEDURE dbo.StoredProcedure4
AS
BEGIN
    SELECT TOP 10
        p.[EnglishProductName] AS ProductName,
         ROUND(SUM(fs.[SalesAmount]), 2) AS TotalSales
    FROM
        [FactSales] fs
    INNER JOIN
        [DimProduct] p ON fs.[ProductKey] = p.[ProductKey]
    GROUP BY
        p.[EnglishProductName]
    ORDER BY
        TotalSales DESC;
END
GO

-- SP5
CREATE PROCEDURE dbo.StoredProcedure5
AS
BEGIN
    SELECT
        c.[EnglishOccupation] AS Occupation,
        ROUND(AVG(fs.[SalesAmount]),2) AS AverageSpendingAmount
    FROM
        [FactSales] fs
    INNER JOIN
        [DimCustomer] c ON fs.[CustomerKey] = c.[CustomerKey]
    GROUP BY
        c.[EnglishOccupation];
END
GO

-- SP6
CREATE PROCEDURE dbo.StoredProcedure6
AS
BEGIN
    SELECT TOP 1
        [EnglishProductName] AS MostExpensiveProductName,
        [ListPrice] AS Price
    FROM
        [DimProduct]
    ORDER BY
        [ListPrice] DESC;
END
GO

-- SP7
CREATE PROCEDURE dbo.StoredProcedure7
AS
BEGIN
    SELECT TOP 1
        [EnglishProductName] AS HighestMarginProductName,
        ([ListPrice] - [StandardCost]) AS Margin
    FROM
        [DimProduct]
    ORDER BY
        ([ListPrice] - [StandardCost]) DESC;
END
GO

