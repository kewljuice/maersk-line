<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>MAERSK LINE</title>
  <meta name="description" content="Apache Web Root">
  <style type="text/css">
    body {
      background: #f0f0f0;
      padding: 20px 50px 20px 135px;
      font-family: Tahoma, Geneva, Arial, Helvetica, sans-serif;
      font-size: 0.813em;
      line-height: 1.5em;
      color: #333;
    }
    h1 {
      font-family: Georgia, "Times New Roman", Times, serif;
      font-size: 2em;
      line-height: 1.2em;
      color: #00467F;
    }
    h2 {
      font-family: Georgia, "Times New Roman", Times, serif;
      font-size: 1.692em;
      line-height: 1.2em;
      color: #000;
    }
    h3 {
      font-family: Tahoma, Geneva, Arial, Helvetica, sans-serif;
      font-size: 1.385em;
      line-height: 1.2em;
      color: #000;
      border-bottom: 1px dotted #c0c0c0;
      padding-bottom: 5px;
    }
    a {
      color: #4E90CD;
      text-decoration: underline;
    }
    a:hover {
      color: #00467F;
    }
    ul {
      margin: 0 0 0 15px;
      padding: 0;
    }
    ul li {
      margin: 0 0 3px 0;
      padding: 0;
    }
    .blok, #blok_todo {
      background: #fff;
      border: 1px solid #e0e0e0;
      padding: 25px 25px 25px 25px;
    }
    #blok_toc {
      position: fixed;
      top: 0;
      left: 0;
      width: 85px;
      background: #fafafa;
      border-right: 1px solid #e0e0e0;
      border-bottom: 1px solid #e0e0e0;
      padding: 50px 15px 15px 15px;
    }
    #blok_toc ul {
      margin: 0;
      padding: 0;
      list-style: none;
    }
    #blok_toc a {
      color: #333;
    }
    #blok_todo {
      border: 3px solid #00467F;
    }
    .old, .old a {
      text-decoration: line-through;
      color: #F00;
    }
    .old a {
      text-decoration: line-through underline;
    }
    @media only screen and (max-width: 480px) {
      body {
        padding: 15px;
      }
      #blok_toc {
        position: relative;
        width: auto;
        margin: 15px 0;
        padding: 15px;
        border: 1px solid #e0e0e0;
      }
    }
  </style>
</head>

<body>
<div id="blok_toc">
  <ul>
    <li><a href="#nginx">NGINX</a></li>
    <li><a href="#mysql">MySQL</a></li>
    <li><a href="#php">PHP</a></li>
    <li><a href="#dir">Directory</a></li>
  </ul>
</div>
<?php
echo "<h1>Docker:</h1>";
?>
<h2 id="nginx">NGINX</h2>
<div id="blok_todo">
  <?php
  $nginxVersion = shell_exec('nginx -v 2>&1`');
  print $nginxVersion;
  ?>
</div>
<h2 id="mysql">MySQL</h2>
<div id="blok_todo">
  <?php
  $mysqli = new mysqli("mysql", "db_user", "db_secret");
  if($mysqli->connect_errno) {
    printf("MySQL Connect failed: %s\n", mysqli_connect_error());
  } else {
    printf("MySQL Version: %s\n", $mysqli->server_version);
  }
  ?>
</div>
</div>
<h2 id="php">PHP</h2>
<div id="blok_todo">
  <?php
  printf("PHP Version: %s\n", phpversion());
  print '<br><br>';
  printf("display_errors = %s, ", ini_get('display_errors'));
  printf("post_max_size = %s, ", ini_get('post_max_size'));
  printf("upload_max_filesize = %s, ", ini_get('upload_max_filesize'));
  printf("max_execution_time = %s, ", ini_get('max_execution_time'));
  printf("max_input_time = %s, ", ini_get('max_input_time'));
  printf("memory_limit = %s, ", ini_get('memory_limit'));
  //phpinfo();
  ?>
</div>
<h2 id="dir">Directory</h2>
<div class="blok">
  <h3>Folders</h3>
  <ul>
    <?php
    $dir = scandir('.');
    foreach ($dir as $value) {
      if (!in_array($value, array('.', '..'))) {
        if (is_dir('.' . DIRECTORY_SEPARATOR . $value)) {
          print "<li><a href='/$value'>$value</a> <a href='/$value/www'>www</a></li>";
        }
      }
    }
    ?>
  </ul>
</div>
</body>
</html>