<%@page import="com.mysql.cj.protocol.Resultset"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <title>Consulta</title>
        <link rel="stylesheet" href="css/tabela.css"/>
        <link rel="stylesheet" href="css/filtro.css"/>
    </head>
    <body>
        <!-- Campos para Filtro -->
        <form method="get" action="" class="filter-container">
            <div class="filter-group">
                <label for="nomeamostra">Nome da Amostra:</label>
                <input type="text" id="nomeamostra" name="nomeamostra" value="<%= request.getParameter("nomeamostra") != null ? request.getParameter("nomeamostra") : "" %>">
            </div>

            <div class="filter-group">
                <label for="datahoraamostra">Data da Amostra:</label>
                <input type="date" id="datahoraamostra" name="datahoraamostra" value="<%= request.getParameter("datahoraamostra") != null ? request.getParameter("datahoraamostra") : "" %>">
            </div>

            <div class="filter-group">
                <label for="cliente">Cliente:</label>
                <input type="text" id="cliente" name="cliente" value="<%= request.getParameter("cliente") != null ? request.getParameter("cliente") : "" %>">
            </div>

            <div class="filter-group">
                <label for="situacao">Situação:</label>
                <select id="situacao" name="situacao">
                    <option value="">Selecione</option>
                    <option value="Recebida" <%= "Recebida".equals(request.getParameter("situacao")) ? "selected" : "" %>>Recebida</option>
                    <option value="Em análise" <%= "Em análise".equals(request.getParameter("situacao")) ? "selected" : "" %>>Em análise</option>
                    <option value="Liberado" <%= "Liberado".equals(request.getParameter("situacao")) ? "selected" : "" %>>Liberado</option>
                </select>
            </div>

            <div class="filter-buttons">
                <button type="submit">Filtrar</button>
                <button type="button" onclick="window.location.href = 'consulta.jsp';">Limpar</button>
            </div>
        </form>

        <%
            try {
                // Conectar ao banco de dados
                Connection conecta;
                PreparedStatement st, stLib;
                Class.forName("com.mysql.cj.jdbc.Driver");
                conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

                // Base SQL para consulta com filtros
                String sql = "SELECT * FROM amostras WHERE 1=1 ";

                if (request.getParameter("nomeamostra") != null && !request.getParameter("nomeamostra").isEmpty()) {
                    sql += "AND nomeamostra LIKE ? ";
                }
                if (request.getParameter("datahoraamostra") != null && !request.getParameter("datahoraamostra").isEmpty()) {
                    sql += "AND DATE(datahoraamostra) = ? ";
                }
                if (request.getParameter("cliente") != null && !request.getParameter("cliente").isEmpty()) {
                    sql += "AND cliente LIKE ? ";
                }

                st = conecta.prepareStatement(sql);

                int paramIndex = 1;
                if (request.getParameter("nomeamostra") != null && !request.getParameter("nomeamostra").isEmpty()) {
                    st.setString(paramIndex++, "%" + request.getParameter("nomeamostra") + "%");
                }
                if (request.getParameter("datahoraamostra") != null && !request.getParameter("datahoraamostra").isEmpty()) {
                    st.setString(paramIndex++, request.getParameter("datahoraamostra"));
                }
                if (request.getParameter("cliente") != null && !request.getParameter("cliente").isEmpty()) {
                    st.setString(paramIndex++, "%" + request.getParameter("cliente") + "%");
                }

                ResultSet rs = st.executeQuery();
        %>
        <table>
            <colgroup>
                <col style="width: 1%;">
                <col style="width: 4%;">
                <col style="width: 4%;">
                <col style="width: 4%;">
                <col style="width: 4%;">
                <col style="width: 4%;">
                <col style="width: 4%;">
            </colgroup>
            <tr>
                <th>ID Amostra</th>
                <th>Nome Amostra</th>
                <th>Data/Hora da Amostra</th>
                <th>Cliente</th>
                <th>Analise</th>
                <th>Situação</th>
                <th>Ações</th>
            </tr>
            <%
                while (rs.next()) {
                    String analise = rs.getString("analise");
                    String idAmostra = rs.getString("idamostra");

                    // Verificar se a amostra está liberada na tabela relatorio_analise
                    stLib = conecta.prepareStatement("SELECT liberado FROM relatorio_analises WHERE idamostra = ?");
                    stLib.setString(1, idAmostra);
                    ResultSet rsLib = stLib.executeQuery();
                    String situacao = "Recebida";
                    if (rsLib.next()) {
                        if ("sim".equalsIgnoreCase(rsLib.getString("liberado"))) {
                            situacao = "Liberado";
                        } else {
                            situacao = "Em análise";
                        }
                    }

                    // Filtro de situação baseado na lógica existente
                    if (request.getParameter("situacao") != null && !request.getParameter("situacao").isEmpty()
                            && !situacao.equals(request.getParameter("situacao"))) {
                        continue; // Ignorar registros que não correspondem ao filtro
                    }

                    rsLib.close();
                    stLib.close();
            %>
            <tr>
                <td><%= rs.getInt("idamostra")%></td>
                <td><%= rs.getString("nomeamostra")%></td>
                <td><%= rs.getTimestamp("datahoraamostra")%></td>
                <td><%= rs.getString("Cliente")%></td>
                <td><%= analise %></td>
                <td><%= situacao %></td>
                <td>
                    <% if (!"Liberado".equals(situacao)) { %>
                    <form action="analise_<%= analise %>.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="idamostra" value="<%= idAmostra %>">
                        <button type="submit">Analisar</button>
                    </form>
                    <form action="excluir_amostra.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="idamostra" value="<%= idAmostra %>">
                        <button type="submit">Excluir</button>
                    </form>
                    <% } %>
                </td>
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
