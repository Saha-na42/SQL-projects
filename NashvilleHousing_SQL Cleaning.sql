 Select *
 From projects..housing_data
 

 --Standarzing date format
 Select SaleDateConverted,  Convert(Date,SaleDate)
 From projects..housing_data

 Alter table projects..housing_data
 Add SaleDateConverted Date

 Update projects..housing_data
 SET SaleDateConverted = convert(Date,Saledate)

 --Populate Property Address data
  Select *
 From projects..housing_data
 where PropertyAddress is null
 order by ParcelID

 Select A.ParcelID,A.PropertyAddress,B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
 From projects..housing_data A
 Join  projects..housing_data B
 On A.ParcelID =B.ParcelID
 And A.[UniqueID ] <> B.[UniqueID ]
 where A.PropertyAddress is null

 Update A
 Set PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
 From projects..housing_data A
 Join  projects..housing_data B
 On A.ParcelID =B.ParcelID
 And A.[UniqueID ] <> B.[UniqueID ]
 where A.PropertyAddress is null

 --Spliting Address into Individual Columns : Address,City,State

  Select PropertyAddress
 From projects..housing_data
 --removing delimiter
 Select 
 Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
 Substring(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress)) as Address 
From projects..housing_data

   Alter table projects..housing_data
 Add PropertySplitAddress Nvarchar(200);

 Update projects..housing_data
 SET PropertySplitAddress =  Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) 

   Alter table projects..housing_data
 Add PropertySplitCity Nvarchar(200);

 Update projects..housing_data
 SET PropertySplitCity =  Substring(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress)) 

  Select *
 From projects..housing_data
 --modifying owner address
 Select OwnerAddress
 From projects..housing_data

 Select
 Parsename(Replace(OwnerAddress, ',' , '.'),3),
  Parsename(Replace(OwnerAddress, ',' , '.'),2),
   Parsename(Replace(OwnerAddress, ',' , '.'),1)
    From projects..housing_data

	 Alter table projects..housing_data
 Add OwnerSplitAddress Nvarchar(200);

 Update projects..housing_data
 SET OwnerSplitAddress =    Parsename(Replace(OwnerAddress, ',' , '.'),3)

   Alter table projects..housing_data
 Add OwnerSplitCity Nvarchar(200);

 Update projects..housing_data
 SET OwnerSplitCity =   Parsename(Replace(OwnerAddress, ',' , '.'),2)

  Alter table projects..housing_data
 Add OwnerSplitState Nvarchar(200);

 Update projects..housing_data
 SET OwnerSplitState =   Parsename(Replace(OwnerAddress, ',' , '.'),1 )

   Select *
 From projects..housing_data

 --Changing Y and N as Yes and No 

  Select Distinct(SoldAsVacant), Count(SoldAsVacant)
 From projects..housing_data
 Group by SoldAsVacant
 order by 2

 Select SoldAsVacant,
 Case when SoldAsVacant ='Y' Then 'YES'
 when SoldAsVacant = 'N' Then 'No'
 Else SoldAsVacant
 End
 From projects..housing_data

 Update  projects..housing_data
 Set  SoldAsVacant = Case when SoldAsVacant ='Y' Then 'YES'
 when SoldAsVacant = 'N' Then 'No'
 Else SoldAsVacant
 End 

 --Removing Duplicates
 
 With RowNumCTE AS(
   Select *,
   ROW_NUMBER() OVER (
   PARTITION BY  ParcelID,
                 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				 UniqueID
				 ) row_num
 From projects..housing_data)

--Select *
 --From RowNumCTE
 --where row_num > 1
 --Order by PropertyAddress 
 
Delete
 From RowNumCTE
 where row_num > 1
 

 --Deleting unused columns

 Select *
 From projects..housing_data

 Alter table projects..housing_data
 Drop column SaleDate,OwnerAddress, TaxDistrict, PropertyAddress

 --