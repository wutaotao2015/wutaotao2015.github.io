
const path = require('path');
var fs = require('fs');


// app.js
// const Koa = require('koa');
// const router = require('koa-route');
// 
// const app = new Koa();
// 
// const main = ctx => {
//   ctx.response.body = 'Hello World';

// put pocket's html in blog directory, no need to contain in this blog
const data = fs.readFileSync(path.resolve(__dirname, '../ril_export.html'), 'utf-8');

console.log(data);
console.log('#####################################');
console.log('pocketFile read done!')
console.log('#####################################');
// 删除不匹配的内容，用正向否定环视定位，.*来具体匹配字符
const regexp = RegExp('(?<=")http(s)?://.*?(?=")', 'g');
let urlArr = [];
while((matches = regexp.exec(data)) != null){
  console.log(matches[0]);
  urlArr.push(matches[0]);
}

console.log('#####################################');
console.log('get url done!')
console.log('#####################################');

const EpubPress = require('epub-press-js');
const ebook = new EpubPress({
    title: 'Tao Pocket WebPages',
    description: 'Personal favourite webpages',
    urls: urlArr 
});
ebook.publish().then(() => {
  // it will download to the current directory
    ebook.download();  // Default epub or ebook.email('epubpress@gmail.com')
}).then(() => {
   console.log('Success!');
}).catch((error) => {
    console.log(`Error: ${error}`);
}).then(() => {
  console.log('#####################################');
  console.log('epub done!');
  console.log('#####################################');
});

// };
// 
// const welcome = (ctx, name) => {
//   ctx.response.body = 'Hello ' + name;
// };
// 
// app.use(router.get('/', main));
// app.use(router.get('/:name', welcome));
// 
// app.listen(3000);
// console.log('listening on port 3000');

