// 定义请求的模式
const pattern = /vapp\.taizhou\.com\.cn/;

// 检查响应是否匹配指定的模式
if ($request && pattern.test($request.url)) {
  const headers = $request.headers;
  const accountId = headers['X-ACCOUNT-ID'];
  const sessionId = headers['X-SESSION-ID'];

  // 检查是否获取到必要的变量
  if (accountId && sessionId) {
    // 将变量存储到 QX 的环境变量中
    $prefs.setValueForKey(accountId, "X-ACCOUNT-ID");
    $prefs.setValueForKey(sessionId, "X-SESSION-ID");

    // 打印日志以便调试
    console.log(`X-ACCOUNT-ID: ${accountId}`);
    console.log(`X-SESSION-ID: ${sessionId}`);
  }
}

// 完成响应处理
$done({});
