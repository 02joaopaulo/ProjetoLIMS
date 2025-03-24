<%@page import="com.mysql.cj.protocol.Resultset"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Resultados Liberados</title>
        <link rel="stylesheet" href="css/tabelaresul.css"/>
        <link rel="stylesheet" href="css/filtro.css"/>
    </head>
    <body>
        <!-- Botões de Exportação -->
        <div class="button-container">
            <button onclick="window.location.href = 'exportar_excel.jsp?<%= request.getQueryString() %>'">Exportar Excel</button>
            <button onclick="window.location.href = 'exportar_pdf.jsp?<%= request.getQueryString() %>'">Exportar PDF</button>
        </div>

        <!-- Campos para Filtro -->
        <form method="get" action="" class="filter-container">
            <div class="filter-group">
                <label for="nomeamostra">Nome da Amostra:</label>
                <input type="text" id="nomeamostra" name="nomeamostra" value="<%= request.getParameter("nomeamostra") != null ? request.getParameter("nomeamostra") : "" %>">
            </div>

            <div class="filter-group">
                <label for="cliente">Cliente:</label>
                <input type="text" id="cliente" name="cliente" value="<%= request.getParameter("cliente") != null ? request.getParameter("cliente") : "" %>">
            </div>

            <div class="filter-group">
                <label for="datahoraamostra">Data da Amostra:</label>
                <input type="date" id="datahoraamostra" name="datahoraamostra" value="<%= request.getParameter("datahoraamostra") != null ? request.getParameter("datahoraamostra") : "" %>">
            </div>

            <div class="filter-group">
                <label for="datahoraliberacaoinicio">Data/Hora da Liberação (Início):</label>
                <input type="datetime-local" id="datahoraliberacaoinicio" name="datahoraliberacaoinicio" value="<%= request.getParameter("datahoraliberacaoinicio") != null ? request.getParameter("datahoraliberacaoinicio") : "" %>">
            </div>

            <div class="filter-group">
                <label for="datahoraliberacaofim">Data/Hora da Liberação (Fim):</label>
                <input type="datetime-local" id="datahoraliberacaofim" name="datahoraliberacaofim" value="<%= request.getParameter("datahoraliberacaofim") != null ? request.getParameter("datahoraliberacaofim") : "" %>">
            </div>

            <div class="filter-buttons">
                <button type="submit">Filtrar</button>
                <button type="button" onclick="window.location.href = 'resultados.jsp';">Limpar</button>
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
                String sql = "SELECT * FROM relatorio_analises WHERE liberado = 'sim' ";

                if (request.getParameter("nomeamostra") != null && !request.getParameter("nomeamostra").isEmpty()) {
                    sql += "AND nomeamostra LIKE ? ";
                }
                if (request.getParameter("cliente") != null && !request.getParameter("cliente").isEmpty()) {
                    sql += "AND cliente LIKE ? ";
                }
                if (request.getParameter("datahoraamostra") != null && !request.getParameter("datahoraamostra").isEmpty()) {
                    sql += "AND DATE(datahoraamostra) = ? ";
                }
                if (request.getParameter("datahoraliberacaoinicio") != null && !request.getParameter("datahoraliberacaoinicio").isEmpty()
                        && request.getParameter("datahoraliberacaofim") != null && !request.getParameter("datahoraliberacaofim").isEmpty()) {
                    sql += "AND datahoraliberacao BETWEEN ? AND ? ";
                }

                st = conecta.prepareStatement(sql);

                int paramIndex = 1;
                if (request.getParameter("nomeamostra") != null && !request.getParameter("nomeamostra").isEmpty()) {
                    st.setString(paramIndex++, "%" + request.getParameter("nomeamostra") + "%");
                }
                if (request.getParameter("cliente") != null && !request.getParameter("cliente").isEmpty()) {
                    st.setString(paramIndex++, "%" + request.getParameter("cliente") + "%");
                }
                if (request.getParameter("datahoraamostra") != null && !request.getParameter("datahoraamostra").isEmpty()) {
                    st.setString(paramIndex++, request.getParameter("datahoraamostra"));
                }
                if (request.getParameter("datahoraliberacaoinicio") != null && !request.getParameter("datahoraliberacaoinicio").isEmpty()
                        && request.getParameter("datahoraliberacaofim") != null && !request.getParameter("datahoraliberacaofim").isEmpty()) {
                    st.setString(paramIndex++, request.getParameter("datahoraliberacaoinicio"));
                    st.setString(paramIndex++, request.getParameter("datahoraliberacaofim"));
                }

                ResultSet rs = st.executeQuery();
        %>
        <table>
            <colgroup>
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
            </colgroup>
            <tr>
                <th>ID Amostra</th>
                <th>Nome Amostra</th>
                <th>Data/Hora da Amostra</th>
                <th>Cliente</th>
                <th>Fe</th>
                <th>SiO2</th>
                <th>Al2O3</th>
                <th>P</th>
                <th>Mn</th>
                <th>PPC</th>
                <th>Umidade</th>
                <th>Data/Hora da Liberação</th>
            </tr>
            <%
                while (rs.next()) {
                    String dataHoraAmostraFormatada = rs.getTimestamp("datahoraamostra").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yy HH:mm"));
                    String dataHoraLiberacaoFormatada = rs.getTimestamp("datahoraliberacao").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yy HH:mm"));
            %>
            <tr>
                <td><%= rs.getInt("idamostra")%></td>
                <td><%= rs.getString("nomeamostra")%></td>
                <td><%= dataHoraAmostraFormatada %></td>
                <td><%= rs.getString("cliente")%></td>
                <td><%= String.format("%.2f", rs.getDouble("fe"))%></td>
                <td><%= String.format("%.2f", rs.getDouble("sio2"))%></td>
                <td><%= String.format("%.2f", rs.getDouble("al2o3"))%></td>
                <td><%= String.format("%.3f", rs.getDouble("p"))%></td>
                <td><%= String.format("%.3f", rs.getDouble("mn"))%></td>
                <td><%= String.format("%.2f", rs.getDouble("ppc"))%></td>
                <td><%= String.format("%.2f", rs.getDouble("umidade"))%></td>
                <td><%= dataHoraLiberacaoFormatada %></td>
            </tr>
            <%
                }
            %>
        </table>
        <%
                st.close();
                conecta.close();
            } catch (Exception e) {
                out.print("Erro na transmissão para o mySQL: " + e.getMessage());
                e.printStackTrace();
            }
        %>
    </body>
</html>
