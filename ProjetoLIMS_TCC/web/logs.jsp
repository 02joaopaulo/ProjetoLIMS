<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Logs do Sistema</title>
        <link rel="stylesheet" href="css/tabelaresul.css"/>
        <link rel="stylesheet" href="css/filtro.css"/>
    </head>
    <body>
        <!-- Campos para Filtro -->
        <form method="get" action="" class="filter-container">
            <div class="filter-group">
                <label for="tela">Tela:</label>
                <input type="text" id="tela" name="tela" value="<%= request.getParameter("tela") != null ? request.getParameter("tela") : "" %>">
            </div>

            <div class="filter-group">
                <label for="acao">Ação:</label>
                <input type="text" id="acao" name="acao" value="<%= request.getParameter("acao") != null ? request.getParameter("acao") : "" %>">
            </div>

            <div class="filter-group">
                <label for="usuario">Usuário:</label>
                <input type="text" id="usuario" name="usuario" value="<%= request.getParameter("usuario") != null ? request.getParameter("usuario") : "" %>">
            </div>

            <div class="filter-group">
                <label for="datahoralog">Data do Log:</label>
                <input type="date" id="datahoralog" name="datahoralog" value="<%= request.getParameter("datahoralog") != null ? request.getParameter("datahoralog") : "" %>">
            </div>

            <div class="filter-buttons">
                <button type="submit">Filtrar</button>
                <button type="button" onclick="window.location.href = 'logs.jsp';">Limpar</button>
            </div>
        </form>

        <%
            try {
                // Conectar ao banco de dados
                Connection conecta;
                PreparedStatement st;
                Class.forName("com.mysql.cj.jdbc.Driver");
                conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

                // Base SQL para consulta com filtros
                String sql = "SELECT * FROM logs WHERE 1=1 ";

                if (request.getParameter("tela") != null && !request.getParameter("tela").isEmpty()) {
                    sql += "AND tela LIKE ? ";
                }
                if (request.getParameter("acao") != null && !request.getParameter("acao").isEmpty()) {
                    sql += "AND acao LIKE ? ";
                }
                if (request.getParameter("usuario") != null && !request.getParameter("usuario").isEmpty()) {
                    sql += "AND usuario LIKE ? ";
                }
                if (request.getParameter("datahoralog") != null && !request.getParameter("datahoralog").isEmpty()) {
                    sql += "AND DATE(datahoralog) = ? ";
                }

                st = conecta.prepareStatement(sql);

                int paramIndex = 1;
                if (request.getParameter("tela") != null && !request.getParameter("tela").isEmpty()) {
                    st.setString(paramIndex++, "%" + request.getParameter("tela") + "%");
                }
                if (request.getParameter("acao") != null && !request.getParameter("acao").isEmpty()) {
                    st.setString(paramIndex++, "%" + request.getParameter("acao") + "%");
                }
                if (request.getParameter("usuario") != null && !request.getParameter("usuario").isEmpty()) {
                    st.setString(paramIndex++, "%" + request.getParameter("usuario") + "%");
                }
                if (request.getParameter("datahoralog") != null && !request.getParameter("datahoralog").isEmpty()) {
                    st.setString(paramIndex++, request.getParameter("datahoralog"));
                }

                ResultSet rs = st.executeQuery();
        %>
        <!-- Tabela para Exibição dos Logs -->
        <table>
            <colgroup>
                <col style="width: 5%;">
                <col style="width: 20%;">
                <col style="width: 35%;">
                <col style="width: 20%;">
                <col style="width: 20%;">
            </colgroup>
            <tr>
                <th>ID Logs</th>
                <th>Tela</th>
                <th>Ação</th>
                <th>Usuário</th>
                <th>Data/Hora do Log</th>
            </tr>
            <%
                while (rs.next()) {
                    String idLogs = rs.getString("idlogs");
                    String tela = rs.getString("tela");
                    String acao = rs.getString("acao");
                    String usuario = rs.getString("usuario");
                    String dataHoraLog = rs.getTimestamp("datahoralog").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
            %>
            <tr>
                <td><%= idLogs %></td>
                <td><%= tela %></td>
                <td><%= acao %></td>
                <td><%= usuario %></td>
                <td><%= dataHoraLog %></td>
            </tr>
            <%
                }
                st.close();
                conecta.close();
            } catch (Exception e) {
                out.print("Erro ao acessar os logs: " + e.getMessage());
                e.printStackTrace();
            }
            %>
        </table>
    </body>
</html>
