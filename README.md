脚本操作甲骨文云创建新用户《有限权限》适合api开机密钥

================================================

甲骨文云创建admin新用户

wget -N "https://raw.githubusercontent.com/jimu2000/public/main/oracle_Create_admin_user.sh" --no-check-certificate && chmod +x oracle_Create_admin_user.sh && bash oracle_Create_admin_user.sh

====================================

脚本操作甲骨文云创建新用户《有限权限》适合api开机密钥

wget -N "https://raw.githubusercontent.com/jimu2000/public/main/oracle_role_apiuser_policy.sh" --no-check-certificate && chmod +x oracle_role_apiuser_policy.sh && bash oracle_role_apiuser_policy.sh

================================================

使用教程： https://telegra.ph/oralce-api-role-05-05

1.打开甲骨文oci

2.打开cloud shell
<img width="1055" height="166" alt="image" src="https://github.com/user-attachments/assets/06c6ceba-2fd0-490b-b726-2e8077e6e984" />


3.运行下面的语句


wget -N "https://raw.githubusercontent.com/jimu2000/public/main/oracle_role_apiuser_policy.sh" --no-check-certificate && chmod +x oracle_role_apiuser_policy.sh && bash oracle_role_apiuser_policy.sh


4.关于运行语句的内容及安全性,有能力的可以查看GitHub

https://github.com/jin-gubang/public/blob/main/oracle_role_apiuser_policy.sh

5.运行后的效果如图
<img width="1111" height="395" alt="image" src="https://github.com/user-attachments/assets/d8279144-19a3-4612-b0d9-607a5183856d" />


6.就会创建出[策略][组][用户]

7.找到用户[User_for_Api_used]创建密钥即可

8.收工~
