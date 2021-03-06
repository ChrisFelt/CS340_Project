-- CS 340 Intro to Databases
-- Project Step 2 Draft: example_data for DDL.sql
-- Team Rock Bottom
-- Members: Robert Behring and Christopher Felt
-- INSERT INTO queries will be tested here before merging
--   with DDL.sql file

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- -----------------------------------------------------
-- Table Users
-- -----------------------------------------------------
CREATE OR REPLACE TABLE Users (
  userID INT NOT NULL AUTO_INCREMENT UNIQUE,
  first_name VARCHAR(75) NOT NULL,
  last_name VARCHAR(75) NOT NULL,
  address VARCHAR(155) NOT NULL,
  specialization VARCHAR(155) NULL,
  bio VARCHAR(3000) NULL,
  CONSTRAINT Unique_Name UNIQUE (first_name, last_name),
  PRIMARY KEY (userID));


-- -----------------------------------------------------
-- Table Rocks
-- -----------------------------------------------------
CREATE OR REPLACE TABLE Rocks (
  rockID INT NOT NULL AUTO_INCREMENT UNIQUE,
  userID INT NOT NULL,
  name VARCHAR(75) NOT NULL,
  geoOrigin VARCHAR(155) NOT NULL,
  type VARCHAR(75) NOT NULL,
  description VARCHAR(255) NOT NULL,
  chemicalComp VARCHAR(155) NOT NULL,
  PRIMARY KEY (rockID),
  CONSTRAINT fk_Rocks_Users1
    FOREIGN KEY (userID)
    REFERENCES Users (userID)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table Reviews
-- -----------------------------------------------------
CREATE OR REPLACE TABLE Reviews (
  reviewID INT NOT NULL AUTO_INCREMENT UNIQUE,
  userID INT NOT NULL,
  rockID INT NOT NULL,
  title VARCHAR(75) NOT NULL,
  body VARCHAR(3000) NOT NULL,
  rating TINYINT(1) UNSIGNED NOT NULL,
  PRIMARY KEY (reviewID),
  CONSTRAINT fk_Reviews_Users1
    FOREIGN KEY (userID)
    REFERENCES Users (userID)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Reviews_Rocks1
    FOREIGN KEY (rockID)
    REFERENCES Rocks (rockID)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table Shipments
-- -----------------------------------------------------
CREATE OR REPLACE TABLE Shipments (
  shipmentID INT NOT NULL AUTO_INCREMENT UNIQUE,
  userID INT NOT NULL,
  shipOrigin VARCHAR(255) NOT NULL,
  shipDest VARCHAR(255) NOT NULL,
  shipDate DATE NOT NULL,
  miscNote VARCHAR(3000) NULL,
  PRIMARY KEY (shipmentID),
  CONSTRAINT fk_Shipments_Users1
    FOREIGN KEY (userID)
    REFERENCES Users (userID)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table Shipments_has_Rocks
-- -----------------------------------------------------
CREATE OR REPLACE TABLE Shipments_has_Rocks (
  shipmentHasRockID INT NOT NULL AUTO_INCREMENT UNIQUE,
  shipmentID INT NOT NULL,
  rockID INT NOT NULL,
  PRIMARY KEY (shipmentHasRockID),
  -- combination of shipmentID and rockID FKs must always be unique
  CONSTRAINT fk_shipmentID_and_rockID_unique UNIQUE (shipmentID, rockID),
  CONSTRAINT fk_Shipments_has_Rocks_Shipments1
    FOREIGN KEY (shipmentID)
    REFERENCES Shipments (shipmentID)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Shipments_has_Rocks_Rocks1
    FOREIGN KEY (rockID)
    REFERENCES Rocks (rockID)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table Users
-- -----------------------------------------------------
INSERT INTO Users ( 
    first_name,
    last_name,
    address,
    specialization,
    bio
)
VALUES (
    'Ricky',
    'Bobby',
    '123 Rocky Road',
    'Rolling Rocks',
    'Ricky has spent most of his life rolling rocks, aiming to be the very best there ever was'
), (
    'Rick',
    'McFarley',
    '101 Sedimentary Way, New York City, NY 10001',
    NULL,
    NULL
), (
    'Bobby',
    'James',
    '6000 Metamorphic Drive, Rock City, NM 87311 USA',
    'Gem Cutter',
    NULL
), (
    'Alice',
    'Liddel',
    '1 Igneous Court, Sydney, NSW 2000 Australia',
    'Amateur Rockhound',
    NULL
), (
    'Jimothy',
    'Riley',
    'Riley Castle Way, London, W1D 3AF United Kingdom',
    'Mineral Photographer',
    "I've spent the last 23 years photographing priceless rocks all across the UK and US."
);

-- -----------------------------------------------------
-- Table Rocks
-- -----------------------------------------------------
INSERT INTO Rocks (
    userID,
    name,
    geoOrigin,
    type,
    description,
    chemicalComp
)
VALUES (
    (SELECT userID FROM Users WHERE first_name='Ricky' AND last_name='Bobby'),
    'Mossy Rock',
    'Appalachia',
    'Igneous',
    'A rock for rolling, has moss growing on it',
    'Quartz, Iron, Magnesium'
), (
    (SELECT userID FROM Users WHERE first_name='Bobby' AND last_name='James'),
    'The One Rock',
    'Mt. Ruapehu, New Zealand',
    'Igneous',
    'Vastly superior to rocks that suffer from any form of plurality.',
    'KALSi3O8'
), (
    (SELECT userID FROM Users WHERE first_name='Alice' AND last_name='Liddel'),
    'Old Man of the Mountain',
    'White Mountains, USA',
    'Igneous',
    'Shard from the OG.',
    'SiO2'
), (
    (SELECT userID FROM Users WHERE first_name='Rick' AND last_name='McFarley'),
    'Scarlet',
    'Wah Wah Mountains, USA',
    'Metamorphic',
    'Uncut red beryl in original rhyolite matrix. So shiny.',
    'Be3Al2Si6O18 + Mn'
), (
    (SELECT userID FROM Users WHERE first_name='Rick' AND last_name='McFarley'),
    'Rocky',
    'K2, Pakistan',
    'Igneous',
    'My little blue buddy',
    'SiO2 + Cu3(CO3)2(OH)2'
);

-- -----------------------------------------------------
-- Table Reviews
-- -----------------------------------------------------
INSERT INTO Reviews (
    userID,
    rockID,
    title,
    body,
    rating
)
VALUES (
    (SELECT userID FROM Users WHERE first_name='Ricky' AND last_name='Bobby'),
    (SELECT rockID FROM Rocks WHERE name='Mossy Rock'),
    'BEST ROCK EVER',
    'The original rolling stone, why would anyone ever want another?',
    5
), (
    (SELECT userID FROM Users WHERE first_name='Bobby' AND last_name='James'),
    (SELECT rockID FROM Rocks WHERE name='Scarlet'),
    'not so good rock',
    "too shiny, didn't like it. ",
    2
), (
    (SELECT userID FROM Users WHERE first_name='Bobby' AND last_name='James'),
    (SELECT rockID FROM Rocks WHERE name='The One Rock'),
    'WOW THAT CRYSTAL STRUCTURE THO',
    'I cut it and ground it down into a thin section just so I could see the FANTASTIC twinning structure of the K-spar crystals under a microscope - THREE DAYS OF ROCK GRINDING WELL SPENT.',
    5
), (
    (SELECT userID FROM Users WHERE first_name='Alice' AND last_name='Liddel'),
    (SELECT rockID FROM Rocks WHERE name='Scarlet'),
    'meh',
    "Kind of your average, middle of the road rock. Honestly I'm not sure what the individual who sent this in was thinking. Clearly the caliber of his or her upbringing is questionable.",
    3
), (
    (SELECT userID FROM Users WHERE first_name='Jimothy' AND last_name='Riley'),
    (SELECT rockID FROM Rocks WHERE name='Rocky'),
    'Nope',
    'Not nearly as good as my rock, which is the best rock.',
    5
);

-- -----------------------------------------------------
-- Table Shipments
-- -----------------------------------------------------
INSERT INTO Shipments (
    userID,
    shipOrigin,
    shipDest,
    shipDate,
    miscNote
)
VALUES (
    (SELECT userID FROM Users WHERE first_name='Ricky' AND last_name='Bobby'),
    'Rocklohoma',
    '123 Rocky Road',
    '2022-02-02',
    'User has requested the rock be rolled to its destination'
), (
    (SELECT userID FROM Users WHERE first_name='Alice' AND last_name='Liddel'),
    '6000 Metamorphic Drive, Rock City, NM 87311 USA',
    '1 Igneous Court, Sydney, NSW 2000 Australia',
    '2022-11-08',
    'VIP, HANDLE WITH CARE'
), (
    (SELECT userID FROM Users WHERE first_name='Jimothy' AND last_name='Riley'),
    '101 Sedimentary Way, New York City, NY 10001',
    'Riley Castle Way, London, W1D 3AF United Kingdom',
    '2023-07-07',
    'Special delivery instructions by Mr. Riley - leave at portcullis #2.'
), (
    (SELECT userID FROM Users WHERE first_name='Alice' AND last_name='Liddel'),
    'Riley Castle Way, London, W1D 3AF United Kingdom',
    '6000 Metamorphic Drive, Rock City, NM 87311 USA',
    '2023-04-10',
    'User has requested the rock be rolled to its destination'
), (
    (SELECT userID FROM Users WHERE first_name='Rick' AND last_name='McFarley'),
    '1 Igneous Court, Sydney, NSW 2000 Australia',
    '101 Sedimentary Way',
    '2022-12-24',
    NULL
);

-- -----------------------------------------------------
-- Table Shipments_has_Rocks
-- -----------------------------------------------------
INSERT INTO Shipments_has_Rocks (
    shipmentID,
    rockID
)
VALUES (
    (SELECT shipmentID FROM Shipments 
        WHERE shipOrigin='Rocklohoma' 
        AND shipDest='123 Rocky Road' 
        AND shipDate='2022-02-02'),
    (SELECT rockID FROM Rocks WHERE name='Mossy Rock')
), (
    (SELECT shipmentID FROM Shipments 
        WHERE shipOrigin='6000 Metamorphic Drive, Rock City, NM 87311 USA' 
        AND shipDest='1 Igneous Court, Sydney, NSW 2000 Australia' 
        AND shipDate='2022-11-08'),
    (SELECT rockID FROM Rocks WHERE name='Scarlet')
), (
    (SELECT shipmentID FROM Shipments 
        WHERE shipOrigin='101 Sedimentary Way, New York City, NY 10001' 
        AND shipDest='Riley Castle Way, London, W1D 3AF United Kingdom' 
        AND shipDate='2023-07-07'),
    (SELECT rockID FROM Rocks WHERE name='Old Man of the Mountain')
), (
    (SELECT shipmentID FROM Shipments 
        WHERE shipOrigin='Riley Castle Way, London, W1D 3AF United Kingdom' 
        AND shipDest='6000 Metamorphic Drive, Rock City, NM 87311 USA' 
        AND shipDate='2023-04-10'),
    (SELECT rockID FROM Rocks WHERE name='Rocky')
), (
    (SELECT shipmentID FROM Shipments 
        WHERE shipOrigin='1 Igneous Court, Sydney, NSW 2000 Australia' 
        AND shipDest='101 Sedimentary Way' 
        AND shipDate='2022-12-24'),
    (SELECT rockID FROM Rocks WHERE name='The One Rock')
);

SET FOREIGN_KEY_CHECKS=1;
COMMIT;
