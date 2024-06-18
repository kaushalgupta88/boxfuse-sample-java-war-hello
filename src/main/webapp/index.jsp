<html>
<head>
    <title>Boxfuse Sample App: success!</title>
</head>
<body style="text-align: center">
<h1>Congratulations!</h1>
<img src="kg.png">

<h2>You have successfully launched your Instance!</h2>


<p style="margin-bottom: 20px;">
    List all running Instances:<br/>
    <strong>boxfuse ps</strong>
</p>

<P style="margin-bottom: 20px;">
    List all Bootable Apps:<br/>
    <strong>boxfuse ls</strong>
</p>

<p>
    Gracefully kill the Instance:<br/>
    <strong>boxfuse kill <%= System.getenv("BOXFUSE_INSTANCE_ID") %>
    </strong>
</p>

<p>
    Deploy this Image unchanged on AWS:<br/>
    <strong>boxfuse run -env=prod <%= System.getenv("BOXFUSE_APP")%>:<%= System.getenv("BOXFUSE_IMAGE_VERSION")%>
    </strong>
</p>
<% } else { %>
<h2 style="margin-top: 80px">Now it's your turn!</h2>


<p>Say goodbye to snowflake servers.</p>
<p><strong>Enjoy Boxfuse!</strong></p>
<% } %>
</body>
</html>
