create database basic;
use basic;

create table dmkhoa(
	MaKhoa varchar(20) primary key,
    TenKhoa varchar(255) 
);

create table dmnganh(
	MaNganh int auto_increment primary key,
    TenNganh varchar(255),
    MaKhoa varchar(20) not null,
    foreign key(MaKhoa) references dmKhoa(MaKhoa)
);

create table dmhocphan(
	MaHP int auto_increment primary key,
    TenHP varchar(255),
    Sodvht int,
    MaNganh int not null,
	HocKy int,
    foreign key(MaNganh) references dmnganh(MaNganh)
);

create table dmlop(
	MaLop varchar(20) primary key,
    TenLop varchar(255),
    MaNganh int not null,
    KhoaHoc int,
    HeDT varchar(255),
    NamNhapHoc int,
    foreign key(MaNganh) references dmnganh(MaNganh)
);

create table sinhvien (
	MaSV int auto_increment primary key,
    HoTen varchar(255),
    MaLop varchar(20),
    GioiTinh tinyint(1),
    NgaySinh date,
    DiaChi varchar(255),
    foreign key(MaLop) references dmlop(MaLop)
);

create table diemhp (
	MaSV int not null,
    MaHP int not null,
    DiemHP float,
    primary key(MaSV,MaHP),
    foreign key(MaSV) references sinhvien(MaSV),
    foreign key(MaHP) references dmhocphan(MaHP)
);

-- insert data

insert into dmkhoa values
("CNTT","Công nghệ thông tin"),
("KT","Kế Toán"),
("SP","Sư Phạm");

insert into dmnganh values
(140902,"Sư phạm toán tin","SP"),
(480202,"Tin học ứng dụng","CNTT");

insert into dmlop values
("CT11","Cao đẳng tin học",480202,11,"TC",2013),
("CT12","Cao đẳng tin học",480202,12,"CĐ",2013),
("CT13","Cao đẳng tin học",480202,13,"TC",2014);

insert into dmhocphan values
(1,"Toán cao cấp A1",4,480202,1),
(2,"Tiếng anh 1",3,480202,1),
(3,"Vật lý đại cương",4,480202,1),
(4,"Tiếng anh 2",7,480202,1),
(5,"Tiếng anh 1",3,140902,2),
(6,"Xắc suất thông kê",3,480202,2);

insert into sinhvien values
(1,"Phan Thanh","CT12",0,"1990-09-12","Tuy Phước"),
(2,"Nguyễn Thị Cẩm","CT12",1,"1994-01-12","Quy Nhơn"),
(3,"Võ Thị Hà","CT12",1,"1995-07-02","An Nhơn"),
(4,"Trần Hoài Nam","CT12",0,"1994-04-05","Tây Sơn"),
(5,"Trần Văn Hoàng","CT13",0,"1995-08-04","Vĩnh Thạnh"),
(6,"Đặng Thị Thảo","CT13",1,"1995-06-12","Quy Nhơn"),
(7,"Lê Thị Sen","CT13",1,"1994-08-12","Phù Mỹ"),
(8,"Nguyễn Văn Huy","CT11",0,"1995-06-04","Tuy Phước"),
(9,"Trần Thị Hoa","CT11",1,"1994-08-09","Hoài Nhơn");

insert into diemhp values
(2,2,5.9),
(2,3,4.5),
(3,1,4.3),
(3,2,6.7),
(3,3,7.3),
(4,1,4),
(4,2,5.2),
(4,3,3.5),
(5,1,9.8),
(5,2,7.9),
(5,3,7.5),
(6,1,6.1),
(6,2,5.6),
(6,3,4),
(7,1,6.2);

-- truy vấn

-- 1. Hiển thị danh sách gồm MaSV, HoTên, MaLop, DiemHP, MaHP của những sinh viên có điểm HP >= 5

select sv.MaSV,sv.HoTen,sv.MaLop,d.DiemHP,d.MaHP from sinhvien sv
join diemhp d on sv.MaSV = d.MaSV
where d.DiemHP >= 5;

-- 2. Hiển thị danh sách MaSV, HoTen, MaLop, MaHP, DiemHP, MaHP được sắp xếp theo ưu tiên MaLop, HoTen tăng dần. (5đ)

select sv.MaSV,sv.HoTen,sv.MaLop,d.MaHP,d.DiemHP from sinhvien sv
join diemhp d on sv.MaSV = d.MaSV
order by sv.MaLop,sv.HoTen;

-- 3. Hiển thị danh sách gồm MaSV, HoTen, MaLop, DiemHP, HocKy của những sinh viên có DiemHP từ 5  7 ở học kỳ I. (5đ)

select sv.MaSV,sv.HoTen,sv.MaLop,d.DiemHP,hp.HocKy from sinhvien sv
join diemhp d on sv.MaSV = d.MaSV
join dmhocphan hp on d.MaHP = hp.MaHP
where (d.DiemHP between 5 and 7) and hp.HocKy = 1;

-- 4. Hiển thị danh sách sinh viên gồm MaSV, HoTen, MaLop, TenLop, MaKhoa của Khoa có mã CNTT (5đ)
 
 select sv.MaSV,sv.HoTen,lop.MaLop,lop.TenLop,ng.MaKhoa from sinhvien sv 
 join dmlop lop on lop.MaLop = sv.MaLop
 join dmnganh ng on ng.MaNganh = lop.MaNganh
 where ng.MaKhoa = "CNTT";
 
-- 5. Cho biết MaLop, TenLop, tổng số sinh viên của mỗi lớp (SiSo): (5đ)
 
 select lop.MaLop,lop.TenLop,count(sv.MaSV) as SiSo from sinhvien sv
 join dmlop lop on sv.MaLop = lop.MaLop
 group by lop.MaLop;
 
-- 6. Cho biết điểm trung bình chung của mỗi sinh viên ở mỗi học kỳ, biết công thức tính DiemTBC như sau:
-- DiemTBC = ∑▒〖(DiemHP*Sodvhp)/∑(Sodvhp)〗

select hp.HocKy,sv.MaSV,(sum(d.DiemHP * hp.Sodvht) / sum(hp.Sodvht)) as DiemTBC from sinhvien sv
join diemhp d on sv.MaSV = d.MaSV 
join dmhocphan hp on d.MaHP = hp.MaHP
group by sv.MaSV,hp.HocKy;

-- 7. Cho biết MaLop, TenLop, số lượng nam nữ theo từng lớp.

select sv.MaLop,lop.TenLop,
case
	when sv.GioiTinh = 0 then "Nam"
	when sv.GioiTinh = 1 then "Nữ"
end 'GioiTinh',
case
	when sv.GioiTinh = 0 then count(sv.MaSV)
	when sv.GioiTinh = 1 then count(sv.MaSV)
end 'SoLuong' from sinhvien sv
join dmlop lop on sv.MaLop = lop.MaLop
group by sv.MaLop,sv.GioiTinh;

-- 8. Cho biết điểm trung bình chung của mỗi sinh viên ở học kỳ 1
-- Biết: DiemTBC = ∑▒〖(DiemHP*Sodvhp)/∑(Sodvhp)〗

select sv.MaSV,(sum(d.DiemHP * hp.Sodvht) / sum(hp.Sodvht)) as DiemTBC from sinhvien sv
join diemhp d on sv.MaSV = d.MaSV 
join dmhocphan hp on d.MaHP = hp.MaHP
where hp.HocKy = 1
group by sv.MaSV;

-- 9. Cho biết MaSV, HoTen, Số các học phần thiếu điểm (DiemHP<5) của mỗi sinh viên

select sv.MaSV,sv.HoTen,count(case when d.DiemHP < 5 then d.MaHP end) SLuong from sinhvien sv
join diemhp d on sv.MaSV = d.MaSV
group by sv.MaSV 
having SLuong > 0;

-- 10. Đếm số sinh viên có điểm HP <5 của mỗi học phần

select MaHP,count(case when DiemHP < 5 then MaSV end) SL_SV_Thieu from diemhp group by MaHP having SL_SV_Thieu > 0;

-- 11. Tính tổng số đơn vị học trình có điểm HP<5 của mỗi sinh viên

select sv.MaSV,sv.HoTen,sum(hp.Sodvht) Tongdvht from dmhocphan hp 
join diemhp d on hp.MaHP = d.MaHP
join sinhvien sv on d.MaSV = sv.MaSV
where d.DiemHP < 5
group by sv.MaSV;

-- 12. Cho biết MaLop, TenLop có tổng số sinh viên >2.

select lop.MaLop,lop.TenLop,count(sv.MaSV) SiSo from dmlop lop
join sinhvien sv on lop.MaLop = sv.MaLop
group by lop.MaLop having SiSo > 2;

-- 13. Cho biết HoTen sinh viên có ít nhất 2 học phần có điểm <5. (10đ)

select sv.MaSV,sv.HoTen,count(hp.MaHP) Soluong from sinhvien sv
join diemhp d on sv.MaSV = d.MaSV
join dmhocphan hp on hp.MaHP = d.MaHP
where d.DiemHP < 5
group by sv.MaSV having Soluong >= 2;

-- 14. Cho biết HoTen sinh viên học ít nhất 3 học phần mã 1,2,3 (10đ)
select sv.HoTen,COUNT(distinct d.MaHP) Soluong
from sinhvien sv
join diemhp d on sv.MaSV = d.MaSV
join dmhocphan hp on d.MaHP = hp.MaHP
where hp.MaHP in (1, 2, 3)
group by sv.MaSV, sv.HoTen
having COUNT(distinct d.MaHP) >= 3;

