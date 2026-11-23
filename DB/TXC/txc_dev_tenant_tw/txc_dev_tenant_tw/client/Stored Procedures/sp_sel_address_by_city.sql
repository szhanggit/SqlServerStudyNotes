CREATE PROCEDURE [client].[sp_sel_address_by_city]
	@CityId int
	, @ProvinceId int output
	, @CountryId int output
AS
BEGIN
	SET XACT_ABORT ON;

	select @ProvinceId = province.dictionary_id, @CountryId = country.dictionary_id from [general].[tb_d_dictionary] city with(nolock)
	inner join [general].[tb_d_dictionary] province with(nolock) on city.parent_id = province.dictionary_id AND province.category = 'StateOrProvince'
	inner join [general].[tb_d_dictionary] country with(nolock) on country.dictionary_id = province.parent_id AND country.category = 'Country'
	where city.category = 'City' AND city.dictionary_id = @CityId

	if((@ProvinceId is not null) AND (@CountryId is not null))
	BEGIN
		return 1;
	END
	ELSE
	BEGIN
		return 0;
	END

    SET NOCOUNT, XACT_ABORT OFF;
END