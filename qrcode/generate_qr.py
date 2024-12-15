from flask import Flask, request, Response
import subprocess

app = Flask(__name__)


@app.route('/generate_qr', methods=['GET'])
def generate_qr():
    data = request.args.get('data')
    if data:
        # 调用 qrencode 命令生成二维码
        cmd = ['qrencode', '-t', 'PNG', '-o', '-', data]
        result = subprocess.run(cmd, stdout=subprocess.PIPE)
        return Response(result.stdout, mimetype='image/png')
    else:
        return "请传入需要生成二维码的数据，参数格式: ?data=你的内容"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8500)
