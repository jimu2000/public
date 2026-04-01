#!/bin/bash
# 修改版：创建一个拥有超级管理员权限的 API 用户
# 1. 将用户加入内置的 Administrators 组
# 2. 删除了冗余的策略创建逻辑

RED="\e[31m"
GREEN="\e[32m"
RESET="\e[0m"

# --- 参数设置 ---
export user_name="Super_Api_User"      # 超级用户名称
export user_des="拥有全权管理权限的API用户"
export user_email="admin@iooc.eu.org"  # 建议填写你的真实邮箱
export ignore_error="0"

# 获取租户OCID
compartment_id=$(oci iam availability-domain list --query 'data[0]."compartment-id"' --raw-output)
echo -e "${GREEN}租户OCID: $compartment_id ${RESET}"

# 1. 获取内置管理员组的 OCID (关键步骤)
# 内置管理员组名称通常就是 Administrators
group_id=$(oci iam group list --name "Administrators" --query 'data[0].id' --raw-output)

if [ "$group_id" == "null" ] || [ "$group_id" == "" ]; then
    echo -e "${RED}错误：无法找到内置管理员组 Administrators，请检查权限。${RESET}"
    exit 1
fi
echo -e "${GREEN}管理员组ID: $group_id${RESET}"

# 2. 检查并创建用户
user_id=$(oci iam user list --name $user_name --query 'data[0].id' --raw-output)

if [ "$user_id" == "null" ] || [ "$user_id" == "" ]; then
    echo -e "正在创建新用户..."
    user_result=$(oci iam user create --name "$user_name" --description "$user_des" --compartment-id "$compartment_id" --email "$user_email" 2>&1)
    
    if echo "$user_result" | grep -q "ServiceError"; then
        echo -e "${RED}用户创建失败${RESET}"
        exit 1
    fi
    user_id=$(echo $user_result | jq -r '.data.id')
    echo -e "${GREEN}超级用户创建成功: $user_id${RESET}"
else
    echo -e "${GREEN}用户已存在，跳过创建${RESET}"
fi

# 3. 将用户添加到超级管理员组
echo -e "正在将用户提升至 Administrators 权限..."
add_result=$(oci iam group add-user --group-id "$group_id" --user-id "$user_id" 2>&1)

if echo "$add_result" | grep -q "ServiceError"; then
    if echo "$add_result" | grep -q "AlreadyExists"; then
        echo -e "${GREEN}用户已经是管理员组成员，无需重复添加。${RESET}"
    else
        echo -e "${RED}提权失败：$(echo "$add_result" | jq -r '.message')${RESET}"
        exit 1
    fi
else
    echo -e "${GREEN}提权成功！用户已获得超级管理员权限。${RESET}"
fi

echo -e "\n---------------------------------------------------"
echo -e "${GREEN}配置完成！${RESET}"
echo -e "请在控制台找到用户: ${RED}$user_name${RESET}"
echo -e "并为其生成 API 密钥 (API Key) 以供 R-探长使用。"
echo -e "---------------------------------------------------\n"
