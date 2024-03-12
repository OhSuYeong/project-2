USE clouddb;

DROP TRIGGER if EXISTS trg_delusertbl;
DROP VIEW if EXISTS v_usertbl;
DROP TABLE IF EXISTS instancetbl, hosttbl,usertbl, delusertbl, v_usertbl;

CREATE TABLE usertbl(
  userid CHAR(8) NOT NULL PRIMARY KEY,
  password CHAR(8) NOT NULL,
  name CHAR(4) NOT NULL, 
  address CHAR(20),
  phone CHAR(13)
);

CREATE TABLE hosttbl(
  hostid INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  hostname CHAR(8),
  zone CHAR(20),
  hostcpusage FLOAT
);
ALTER TABLE hosttbl AUTO_INCREMENT = 2222;

CREATE TABLE instancetbl(
  userid CHAR(8) NOT NULL,
  vmid INT AUTO_INCREMENT NOT NULL,
  vmname CHAR(8),
  os CHAR(20),
  flavor CHAR(10),
  vmcpusage FLOAT,
  hostid INT,
  PRIMARY KEY (vmid),
  CONSTRAINT FK_hosttbl_instancetbl FOREIGN KEY(hostid) REFERENCES hosttbl(hostid),
  CONSTRAINT FK_usertbl_instancetbl FOREIGN KEY(userid) REFERENCES usertbl(userid)
);
ALTER TABLE instancetbl AUTO_INCREMENT = 1111;


CREATE TABLE delusertbl(
  userid CHAR(8) NOT NULL,
  name CHAR(4) NOT NULL,
  deldate DATE
);clouddb

delimiter //
CREATE TRIGGER trg_delusertbl
  AFTER delete
  ON usertbl
  FOR EACH ROW
BEGIN
  INSERT INTO delusertbl
    VALUES (OLD.userid, OLD.name, CURDATE() );
END //
delimiter ;

CREATE VIEW v_usertbl
AS
SELECT I.vmid AS 'ID', I.vmname AS '인스턴스명', I.flavor AS '위치', I.vmcpusage 'CPU 사용량(%)'
FROM usertbl U
  INNER JOIN instancetbl I
    ON U.userid=I.userid ;

-- usertbl에 더 많은 데이터 추가
INSERT INTO usertbl (userid, password, name, address, phone)
VALUES
('user003', 'pass9999', 'Ali', '789 Elm St', '555-1234'),
('user004', 'pass7777', 'Bob', '101 Pine St', '111-9876'),
('user005', 'pass5555', 'Eve', '202 Oak St', '222-6789');

-- hosttbl에 더 많은 데이터 추가
INSERT INTO hosttbl (hostname, zone, hostcpusage)
VALUES
('worker1','Zone C', 75.0),
('worker2','Zone D', 85.5),
('worker1','Zone E', 95.2);

-- instancetbl에 더 많은 데이터 추가
INSERT INTO instancetbl (userid, vmname, os, flavor, vmcpusage, hostid)
VALUES
('user003','VM003', 'Linux', 'Medium', 25.5, 2222),
('user004','VM004', 'Windows', 'Large', 35.2, 2223),
('user005','VM005', 'Linux', 'Small', 18.8, 2224);