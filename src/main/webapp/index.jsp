<html>
<head>
    <title>Boxfuse Sample App: success!</title>
</head>
<body style="text-align: center">
<h1>Many Many Many Congratulations!</h1>
<img src="kg.png">

<h2>Papa & Manya!</h2>

<% if("virtualbox".equals(System.getenv("BOXFUSE_PLATFORM_ID"))) { %>
<h2 style="margin-top: 80px">Next steps</h2>

<p style="margin-bottom: 20px;">
    Display the Instance console:<br/>
    <strong>boxfuse logs <%= System.getenv("BOXFUSE_INSTANCE_ID") %>
    </strong>
</p>

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
<h2 style="margin-top: 80px">Enjoying in Shimla!</h2>


<% } %>
</body>
</html>
