<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <title>Verificação de e-mail</title>
    <style>
        body {
            background-image: url('{{ asset("https://doitall.com.br/img/background.png") }}');
            background-size: cover;
            background-repeat: no-repeat;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: Arial, sans-serif;
        }
        .message {
            text-align: center;
            background-color: #00242f;
            color: #FFFFFF;
            padding: 20px;
            border-radius: 10px;
        }
        .code {
            font-size: 40px;
            font-weight: bold;
            margin-top: 20px;
            margin-bottom: 20px;
            background-color: #FFFFFF;
            color: #FF0000;
            padding: 10px;
            border-radius: 5px;
        }
    </style>
</head>
<body style="background-image: url('https://doitall.com.br/img/background.png');">
    <div class="message">
        <img class="img-fluid mx-auto d-block" src="https://doitall.com.br/img/logo.png" alt="New York" width="200" height="200">
        <p>Olá </p>
        <p>O usuario do aplicativo Doitall, {{ $name }}, solicitou cadastro desta empresa.</p>
        <p>Caso não esta pessoa não tenha autoração, nos responda este email:</p>

    </div>
</body>
</html>


