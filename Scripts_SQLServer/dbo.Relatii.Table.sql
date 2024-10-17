USE [Precis]
GO
/****** Object:  Table [dbo].[Relatii]    Script Date: 17.10.2024 12:24:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Relatii](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IdNodStart] [int] NOT NULL,
	[IdNodEnd] [int] NOT NULL,
	[Pondere] [int] NOT NULL,
	[NumeNodStart] [varchar](50) NOT NULL,
	[NumeNodEnd] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Relatii] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
