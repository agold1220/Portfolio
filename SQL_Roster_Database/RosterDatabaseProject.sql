

-- Andrew Gold and Kolin Boorom
-- Final Project

USE student28;


CREATE TABLE Player_info(
    Player_id		VARCHAR(255)	NOT NULL,
    Name			VARCHAR(255)	NOT NULL,
    Grad_Year		VARCHAR(4)		NOT NULL,
    Position		VARCHAR(10)		NOT NULL,
    HS				VARCHAR(255),
    Hometown		VARCHAR(255),
    State			VARCHAR(255),
    Email			VARCHAR(255),
    Height			INT,
    Weight			INT,
    PRIMARY KEY (Player_id) 
);

CREATE TABLE Hitters (
	Player_id		VARCHAR(255)	NOT NULL,
    Position		VARCHAR(10)		NOT NULL,
    Handedness		VARCHAR(255)	NOT NULL,
    Hit				INT				NOT NULL,
    Power			INT				NOT NULL,
    Field			INT				NOT NULL,
    Arm				INT				NOT NULL,
    Speed			INT				NOT NULL,
	Priority		VARCHAR(255)	NOT NULL,
    PRIMARY KEY (Player_id)
);


CREATE TABLE Pitchers (
	Player_id			VARCHAR(255)	NOT NULL,
	Handedness			VARCHAR(255)	NOT NULL,
    Starter_Reliever	VARCHAR(255)	NOT NULL,
    FB					INT,
    CB					INT,
    SL					INT,
    CH					INT,
    SNK					INT,
    OTH					INT,
    Command				INT				NOT NULL,
    Priority			VARCHAR(255)	NOT NULL,
    PRIMARY KEY (Player_id)
);



CREATE TABLE Player_Notes (
	Player_id	VARCHAR(255)	NOT NULL,
    Notes		VARCHAR(500),
	PRIMARY KEY (Player_id)
);


INSERT INTO Hitters (Player_id, Position, Handedness, Hit, Power, Field, Arm, Speed, Priority) VALUES('1', 'CF', 'R/R', '40', '55', '40', '50', '35', 'Medium');
INSERT INTO Hitters (Player_id, Position, Handedness, Hit, Power, Field, Arm, Speed, Priority) VALUES('2', 'IF/OF', 'R/R', '60', '45', '50', '50', '40', 'High');
INSERT INTO Hitters (Player_id, Position, Handedness, Hit, Power, Field, Arm, Speed, Priority) VALUES('3', 'RF', 'L/L', '55', '45', '60', '55', '65', 'High');
INSERT INTO Hitters (Player_id, Position, Handedness, Hit, Power, Field, Arm, Speed, Priority) VALUES('4', 'SS', 'R/L', '55', '35', '50', '40', '40', 'Medium');
INSERT INTO Hitters (Player_id, Position, Handedness, Hit, Power, Field, Arm, Speed, Priority) VALUES('7', 'CF', 'R/R', '60', '60', '70', '65', '75', 'High');
INSERT INTO Hitters (Player_id, Position, Handedness, Hit, Power, Field, Arm, Speed, Priority) VALUES('9', '3B', 'R/R', '50', '60', '40', '50', '35', 'Low');


SELECT * FROM Hitters;

INSERT INTO Pitchers (Player_id, Handedness, Starter_Reliever, FB, CB, SL, CH, SNK, OTH, Command, Priority) VALUES('5', 'RHP', 'Reliever', '60', NULL , '50', '40', NULL , NULL , '50',  'Medium');
INSERT INTO Pitchers (Player_id, Handedness, Starter_Reliever, FB, CB, SL, CH, SNK, OTH, Command, Priority) VALUES('6', 'LHP', 'Reliever', '60', '60', '60', '40', NULL, NULL, '50',  'High');
INSERT INTO Pitchers (Player_id, Handedness, Starter_Reliever, FB, CB, SL, CH, SNK, OTH, Command, Priority) VALUES('8', 'LHP', 'Reliever', '60', NULL, '55', NULL, NULL, NULL, '55',  'High');
INSERT INTO Pitchers (Player_id, Handedness, Starter_Reliever, FB, CB, SL, CH, SNK, OTH, Command, Priority) VALUES('10', 'LHP', 'Reliever', '40', '45', NULL, '40', NULL, NULL, '50',  'Low');
INSERT INTO Pitchers (Player_id, Handedness, Starter_Reliever, FB, CB, SL, CH, SNK, OTH, Command, Priority) VALUES('11', 'RHP', 'Starter', '70', NULL, '60', '45', NULL, NULL, '45',  'High');

SELECT * FROM Pitchers;

INSERT INTO Player_info(Player_id, Name, Grad_Year, Position, HS,Hometown,State,Email,Height,Weight) 
VALUES('1','Mykanthony Valdez', '2020','CF','Calvary Christian','Davie','FL','MykanthonyValdez@gmail.com','73','226');
INSERT INTO Player_info(Player_id, Name, Grad_Year, Position, HS,Hometown,State,Email,Height,Weight) 
VALUES('2','CJ Kayfus', '2022','IF/OF','Palm Beach Central','Wellington','FL','CJKayfus@gmail.com','72','175');
INSERT INTO Player_info(Player_id, Name, Grad_Year, Position, HS,Hometown,State,Email,Height,Weight) 
VALUES('3','Chad Born', '2021','RF','Orange Lutheran','Placentia','CA','ChadBorn@gmail.com','70','190');
INSERT INTO Player_info(Player_id, Name, Grad_Year, Position, HS,Hometown,State,Email,Height,Weight) 
VALUES('4','Anthony Vilar', '2023','SS','Westminster Christian','Miami','FL','AnthonyVilar@gmail.com','71','190');
INSERT INTO Player_info(Player_id, Name, Grad_Year, Position, HS,Hometown,State,Email,Height,Weight) 
VALUES('5','Anthony Arguelles', '2022','RHP','Santa Fe College / Columbus','Miami','FL','AnthonyArguelles@gmail.com','72','190');
INSERT INTO Player_info(Player_id, Name, Grad_Year, Position, HS,Hometown,State,Email,Height,Weight) 
VALUES('6','JP Gates', '2022','LHP','Nature Coast','Brooksville','FL','JPGates@gmail.com','74','195');
INSERT INTO Player_info(Player_id, Name, Grad_Year, Position, HS,Hometown,State,Email,Height,Weight) 
VALUES('7','Mike Rosario', '2021','OF','St. Johns River State / Buchholz','Newberry','FL','MikeRosario@gmail.com','72','180');
INSERT INTO Player_info(Player_id, Name, Grad_Year, Position, HS,Hometown,State,Email,Height,Weight) 
VALUES('8','Carson Palmquist', '2023','LHP','Riverdale','Fort Myers','FL','CarsonPalmquist@gmail.com','71','222');
INSERT INTO Player_info(Player_id, Name, Grad_Year, Position, HS,Hometown,State,Email,Height,Weight) 
VALUES('9','Raymond Gil', '2022','3B','Gulliver Prep','Miami','FL','RaymondGil@gmail.com','72','175');
INSERT INTO Player_info(Player_id, Name, Grad_Year, Position, HS,Hometown,State,Email,Height,Weight) 
VALUES('10','Spencer Bodanza', '2021','LHP','Hillsborough CC / Alonso','Tampa','FL','SpencerBodanza@gmail.com','76','186');
INSERT INTO Player_info(Player_id, Name, Grad_Year, Position, HS,Hometown,State,Email,Height,Weight) 
VALUES('11','Alex McFarlane', '2024','RHP','Habersham Central','St. Thomas','USVI','AlexMcFarlane@gmail.com','73','192');

SELECT * FROM Player_info;

INSERT INTO Player_Notes(Player_id, Notes)
VALUES ('1', 'Power bat with limited defense. May need to move positions, possible middle of the order bat');
INSERT INTO Player_Notes(Player_id, Notes)
VALUES ('2', 'High leverage lefty reliever. Good fastball arm-side sink. Above-Average breaking balls.');
INSERT INTO Player_Notes(Player_id, Notes)
VALUES ('3', 'Good defensive outfielder with speed. Could grow into top of the order bat.');
INSERT INTO Player_Notes(Player_id, Notes)
VALUES ('4', 'Limited range and bat. Average tools across the board. Possible future catcher');
INSERT INTO Player_Notes(Player_id, Notes)
VALUES ('5', 'Young right handed pitcher. Possible midweek starter');
INSERT INTO Player_Notes(Player_id, Notes)
VALUES ('6', 'Lefty reliever with plus breaking balls and above average fastball. Some control concerns.');
INSERT INTO Player_Notes(Player_id, Notes)
VALUES ('7', 'Above average to plus tools across the board. Future impact bat.');
INSERT INTO Player_Notes(Player_id, Notes)
VALUES ('8', 'High leverage lefty reliever. Possible future starter. Sidearm release point.');
INSERT INTO Player_Notes(Player_id, Notes)
VALUES ('9', 'Limited defensively, probably future first baseman. Power will determine his future.');
INSERT INTO Player_Notes(Player_id, Notes)
VALUES ('10', 'Mop up reliever. Average command.');
INSERT INTO Player_Notes(Player_id, Notes)
VALUES ('11', 'High end weekend starter. Plus Fastball and breaking ball. Some command issues');

SELECT * FROM Player_Notes;
-- Views

CREATE VIEW High_Priority_Players AS
SELECT
i.name,
Priority
FROM (SELECT Player_id, Priority FROM Hitters UNION
SELECT Player_id, Priority FROM Pitchers) bigtable
JOIN Player_info i
	ON bigtable.Player_id = i.Player_id
WHERE Priority = 'High';

CREATE VIEW Players_From_Miami AS
SELECT *
FROM Player_info
WHERE Hometown = 'Miami';

CREATE VIEW Up_The_Middle AS
SELECT
p.Name,
h.position
FROM Hitters h
	JOIN Player_info p
		ON p.Player_id = h.Player_id
WHERE h.Position = 'SS' OR h.position = 'C' OR h.position = 'CF';


-- Procedures
DELIMITER $$

-- Update Player HS
CREATE PROCEDURE update_player_HS(IN p_Player_id VARCHAR(255), IN p_HS VARCHAR(255))
BEGIN
UPDATE Player_info SET HS = p_HS WHERE Player_id = p_Player_id;
END $$


-- Update Player Notes
CREATE PROCEDURE update_player_notes(IN p_Player_id VARCHAR(255), IN p_Player_Notes VARCHAR(255))
BEGIN
UPDATE Player_Notes SET Player_Notes = p_Player_Notes WHERE Player_id = p_Player_id;
END $$


-- Update Hitter Priority
CREATE PROCEDURE update_hitter_priority(IN p_Player_id VARCHAR(255), IN p_Player_Priority VARCHAR(255))
BEGIN
UPDATE Hitters SET Priority = p_Player_Priority WHERE Player_id = p_Player_id;
END $$


-- Update Pitcher Priority
CREATE PROCEDURE update_pitcher_priority(IN p_Player_id VARCHAR(255), IN p_Player_Priority VARCHAR(255))
BEGIN
UPDATE Pitchers SET Priority = p_Player_Priority WHERE Player_id = p_Player_id;
END $$


-- Delete Player
CREATE PROCEDURE delete_player(IN p_Player_id VARCHAR(255))
BEGIN
DELETE FROM Player_info WHERE Player_id = p_Player_id;
END $$


-- Insert New Player
CREATE PROCEDURE insert_new_Player(IN p_Player_id VARCHAR(255), IN p_Name VARCHAR(255),IN p_Grad_Year VARCHAR(4), IN p_Position VARCHAR(10),
					p_HS VARCHAR(255), IN p_Hometown VARCHAR(255), IN p_State VARCHAR(255), IN p_Email VARCHAR(255),
                    IN p_Height INT, IN p_Weight INT)
BEGIN
		INSERT INTO Player_info (Player_id, Name, Grad_Year, Position, HS, Hometwon, State, Email, Height, Weight) 
		VALUES (p_Player_id, p_Name, p_Grad_Year, p_Position, p_HS, p_Hometwon, p_State, p_Email, p_Height, p_Weight);
END $$

DELIMITER ;

