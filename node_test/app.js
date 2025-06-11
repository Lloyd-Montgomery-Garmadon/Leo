const WebSocket = require('ws');

const PORT = 7788;
const wss = new WebSocket.Server({ port: PORT });

console.log(`[WS] WebSocket 服务运行中: ws://192.168.31.163:${PORT}`);

wss.on('connection', (ws, req) => {
    const clientIP = req.socket.remoteAddress;
    console.log(`[WS] 客户端连接: ${clientIP}`);

    // 立即发一条欢迎信息
    const welcomeMsg = {
        eventType: 'system',
        subType: 'welcome',
        message: '欢迎连接 WebSocket 服务器',
        time: new Date().toISOString()
    };
    ws.send(JSON.stringify(welcomeMsg));
    console.log(`[WS] 发送欢迎信息: ${JSON.stringify(welcomeMsg)}`);

    // 定时发送 chat:message
    const chatInterval = setInterval(() => {
        const chatMsg = {
            eventType: 'chat',
            subType: 'message',
            content: '这是来自服务器的聊天消息',
            time: new Date().toISOString()
        };
        ws.send(JSON.stringify(chatMsg));
        console.log(`[WS] 发送聊天消息: ${JSON.stringify(chatMsg)}`);
    }, 3000);

    // 定时发送 system:update
    const systemInterval = setInterval(() => {
        const sysMsg = {
            eventType: 'system',
            subType: 'update',
            version: '1.0.' + Math.floor(Math.random() * 10),
            time: new Date().toISOString()
        };
        ws.send(JSON.stringify(sysMsg));
        console.log(`[WS] 发送系统更新: ${JSON.stringify(sysMsg)}`);
    }, 5000);

    ws.on('message', (message) => {
        console.log(`[WS] 收到客户端消息: ${message}`);
    });

    ws.on('close', () => {
        console.log(`[WS] 客户端断开连接: ${clientIP}`);
        clearInterval(chatInterval);
        clearInterval(systemInterval);
    });

    ws.on('error', (err) => {
        console.error(`[WS] 客户端错误: ${err.message}`);
    });
});

