<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    String perfil = String.valueOf(session.getAttribute("perfil"));
    Object telasObj = session.getAttribute("telas");

    List<String> telas = null;
    if (telasObj instanceof String[]) {
        telas = Arrays.asList((String[]) telasObj);
    } else if (telasObj instanceof List) {
        telas = (List<String>) telasObj;
    }

    if (usuario == null || telas == null || perfil == null) {
        response.sendRedirect("menu.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Menu - LIMS</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/styles.css"/>
    </head>
    <body>
        <header>
            <img src="image/logo.png" alt="LIMS Logo">
        </header>
        <nav>
            <% if (telas.contains("login")) { %>
                <a href="index.html" target="️Login">️🔐 Login</a>
            <% } %>
            <% if (telas.contains("usuarios")) { %>
                <a href="usuarios.jsp" target="principal">🙎🏻‍ ️Usuários</a>
            <% } %>
            <% if (telas.contains("logs")) { %>
                <a href="logs.jsp" target="principal">📗 Logs</a>
            <% } %>
            <% if (telas.contains("cadastro")) { %>
                <a href="cadastro.jsp" target="principal">📝 Cadastro</a>
            <% } %>
            <% if (telas.contains("consulta")) { %>
                <a href="consulta.jsp" target="principal">📚 Consulta</a>
            <% } %>
            <% if (telas.contains("liberacao")) { %>
                <a href="liberacao.jsp" target="principal">✅ Liberação</a>
            <% } %>
            <% if (telas.contains("resultados")) { %>
                <a href="resultados.jsp" target="principal">📊 Resultados</a>
            <% } %>
            <% if (telas.contains("estoque")) { %>
                <a href="estoque.jsp" target="principal">📦 Estoque</a>
            <% } %>
        </nav>
        <main>
            <iframe src="home.html" name="principal"></iframe>
        </main>
        <footer>
            <p>Desenvolvido por João Paulo Santos</p>
        </footer>
    </body>
</html>
