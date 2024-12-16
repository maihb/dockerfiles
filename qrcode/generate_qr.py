from flask import Flask, request, Response # type: ignore
import qrcode 
import io 

app = Flask(__name__)


@app.route('/generate_qr', methods=['GET'])
def generate_qr():
    data = request.args.get('data')
    if data:
        img = qrcode.make(data=data)
        # 将二维码图像保存到字节流中
        img_io = io.BytesIO()
        img.save(img_io, 'PNG')
        img_io.seek(0)
        return Response(img_io, mimetype='image/png')
    else:
        return "请传入需要生成二维码的数据，参数格式: ?data=你的内容"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8500)
