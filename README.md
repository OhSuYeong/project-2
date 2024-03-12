# project-2
## 구현 요소

1. **계정 생성 및 권한 설정:**
- **`root/test123` 계정으로 전체 관리자 권한을 가지고 로그인합니다.**
- **`dev1/test123` 계정을 생성하고, `clouddb` 데이터베이스에 대한 모든 권한을 부여합니다. `dev1`은 원격 접속만 가능해야 하며, 로컬 접속은 허용하지 않습니다.**
1. **데이터베이스 및 테이블 구성:**
- **`clouddb` 데이터베이스를 생성합니다.**
- **`usertbl` 테이블에는 `userid`, `password`, `name`, `address`, `phone` 컬럼이 있습니다.**
- **`instancetbl` 테이블에는 `userid`, `vmid`, `vmname`, `os`, `flavor`, `vmcpusage`, `hostid` 컬럼이 있으며, `userid`는 `usertbl`의 외래키이고, `vmid`는 자동 증가하는 기본키입니다.**
- **`hosttbl` 테이블에는 `hostid`, `hostname`, `zone`, `hostcpusage` 컬럼이 있으며, `hostid`는 자동 증가하는 기본키입니다.**
1. **PK-FK 관계 설정:**
- **세 테이블간 적절한 기본키-외래키(PK-FK) 관계를 설정합니다.**
1. **추가 기능:**
- **사용자가 삭제되면 해당 정보와 탈퇴 날짜를 별도의 테이블에 기록하는 트리거를 설정합니다.**
- **회원이 로그인하여 대시보드에 접속했을 때 확인할 수 있는 정보를 위한 가상 테이블 또는 뷰를 생성합니다.**
1. **도구 사용:**
- **HeidiSQL의 쿼리 창을 사용하여 데이터베이스를 설정합니다.**
- **dbForge에서 작업 결과를 다이어그램으로 캡처합니다.**
## 구현 진행

### [USER : root]에서 진행

1. 우선 clouddb 생성

```sql
create database `clouddb`;
```

1. 새로운 user 생성 (dev1)

```sql
	create user 'dev1'@'%' identified by 'test123';
```

1. 다른 데이터베이스로의 차단

```sql
REVOKE ALL PRIVILEGES ON *.* FROM 'dev1'@'%';
```

1. 권한 부여

```sql
GRANT ALL PRIVILEGES ON clouddb.* TO 'dev1'@'%';
```

### [USER : dev1]에서 진행

1. 데이터 베이스 및 테이블 구성과 PK-FK 관계 설정, 트리거, 뷰 생성

- 삭제 시 주의할 사항 참조하는 자식 행부터 삭제해야 함. 아래는 쿼리 창에서 진행

```sql
-- 예: 'user003'를 삭제하기 전에 해당하는 'instancetbl' 행 삭제
DELETE FROM instancetbl WHERE userid = 'user003';
DELETE FROM usertbl WHERE userid = 'user003';
```

**[대시 보드 확인]**

**[dbforge에서 다이어그램]**

![1 PNG](https://github.com/OhSuYeong/project-2/assets/101083171/41b4931e-bd5c-49d4-9b60-e5bdca5803d5)
