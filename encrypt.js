// encrypt.js
const crypto = require('crypto');

const keyStr = '703a27c1d227676yfe6fb1d9134a4411';
const payload = { email: 'jamesbrown39@gmail.com', password: 'C7XBdELkxO' };

const payloadStr = JSON.stringify(payload);

// 1) SHA-256 key
const key = crypto.createHash('sha256').update(keyStr, 'utf8').digest(); // 32 bytes

// 2) iv 16 bytes
const iv = crypto.randomBytes(16);

// 3) AES-256-CBC encrypt (PKCS#7 compatible with Java's PKCS5Padding)
const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);
let encrypted = Buffer.concat([cipher.update(Buffer.from(payloadStr, 'utf8')), cipher.final()]);

// 4) combine iv + ciphertext then base64
const combined = Buffer.concat([iv, encrypted]);
const base64 = combined.toString('base64');

console.log('BASE64:', base64);

// --- verify decrypt locally (just to be sure) ---
const decipher = crypto.createDecipheriv('aes-256-cbc', key, iv);
let decrypted = Buffer.concat([decipher.update(encrypted), decipher.final()]);
console.log('DECRYPTED:', decrypted.toString('utf8'));
