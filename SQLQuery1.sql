
--  1.	Create a view named ‘ViewStaffInformation’ 
--	to display StaffName, StaffGender, 
--	StaffDOB (obtained from StaffDOB with ‘Mon dd, yyyy’ format), 
--	and StaffSalary for every staff whose salary lower than 3500000.
--	(CREATE VIEW, CONVERT)

GO
CREATE VIEW [ViewStaffInformation] AS
	SELECT StaffName, StaffGender, CONVERT(varchar, StaffDOB, 107) AS StaffDOB,
		   StaffSalary
	FROM MsStaff
	WHERE StaffSalary < 3500000
SELECT * FROM [ViewStaffInformation]

--  2. Display CustomerName, CustomerGender, CustomerPhone, and CustomerEmail 
--	for every customer who has done transaction on 6th month (June).
--	(IN, MONTH)

SELECT CustomerName, CustomerGender, CustomerPhone, CustomerEmail 
FROM MsCustomer
WHERE CustomerID IN
	(
		SELECT CustomerID
		FROM TransactionHeader
		WHERE MONTH(TransactionDate) = 6
	)

--  3.	Display CustomerID, CustomerName, 
--	Total Purchase (obtained from total number of transactions each customer), 
--	and Month of Purchase (obtained from the name of month TransactionDate)
--	for every customer who has done transaction on the 12nd day. 
--	Then combine it with CustomerID, CustomerName, 
--	Total Purchase (obtained from total number of transactions each customer),
--	Month of Purchase (obtained from the name of month TransactionDate) 
--	for every customer who has done transaction on the 30th day.
--	(COUNT, DATENAME, MONTH, DAY, UNION, GROUP BY)

SELECT mc.CustomerID, CustomerName, COUNT(TransactionID) AS [Total Purchase],
	   DATENAME(MONTH, TransactionDate) AS [Month of Purchase]
FROM MsCustomer mc JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
WHERE DAY(TransactionDate) = 12 
GROUP BY mc.CustomerID, CustomerName, DATENAME(MONTH, TransactionDate)
UNION
SELECT mc.CustomerID, CustomerName, COUNT(TransactionID) AS [Total Purchase],
	   DATENAME(MONTH, TransactionDate) AS [Month of Purchase]
FROM MsCustomer mc JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
WHERE DAY(TransactionDate) = 30
GROUP BY mc.CustomerID, CustomerName, DATENAME(MONTH, TransactionDate)

--  4.	Display PuddingID, PuddingName, and 
--	Total Income (obtained from the amount of all the quantities of each pudding sold multiplied by the price of each pudding) 
--	for every transaction which happened between April 10th, 2021 until 5 days after April 10th, 2021 
--	and the price of pudding more than or equals 30000.
--	(SUM, JOIN, BETWEEN, DATEADD, DAY, GROUP BY)

SELECT mp.PuddingID, PuddingName, SUM(Quantity * PuddingPrice) AS [Total Income]
FROM MsPudding mp JOIN TransactionDetail td ON mp.PuddingID = td.PuddingID
	 JOIN TransactionHeader th ON td.TransactionID = th.TransactionID
WHERE TransactionDate BETWEEN '2021-4-10' AND DATEADD(DAY, 5, '2021-4-10') 
	  AND PuddingPrice >= 30000
GROUP BY mp.PuddingID, PuddingName

-- 5.	Display StaffName (obtained from StaffName with lower case format), 
--	TransactionDate, Flavor (obtained from the first word of PuddingName), 
--	and Quantity 
--	for every transaction which the pudding price less than average all of pudding price 
--	and the quantity more than or equals 5.
--	(LOWER, LEFT, CHARINDEX, AVG, alias subquery)

SELECT LOWER(StaffName) AS StaffName, TransactionDate,
	   LEFT(PuddingName, CHARINDEX(' ', PuddingName) - 1), Quantity
FROM MsStaff ms JOIN TransactionHeader th ON ms.StaffID = th.StaffID 
	 JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
	 JOIN MsPudding mp ON td.PuddingID = mp.PuddingID,
	 (
		SELECT AVG(PuddingPrice) AS Rata2
		FROM MsPudding
	 ) AS Subquery1
WHERE PuddingPrice < Subquery1.Rata2 AND Quantity  >= 5




