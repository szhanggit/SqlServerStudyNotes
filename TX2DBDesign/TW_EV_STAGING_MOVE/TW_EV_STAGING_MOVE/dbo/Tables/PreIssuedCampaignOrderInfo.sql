CREATE TABLE [dbo].[PreIssuedCampaignOrderInfo] (
    [OrderNumber]     VARCHAR (50) NOT NULL,
    [ProductCode]     VARCHAR (50) NOT NULL,
    [ReservationCode] VARCHAR (20) NOT NULL,
    [Id]              INT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_PreIssuedCampaignOrderInfo_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

