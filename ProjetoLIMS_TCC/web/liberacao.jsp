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
        <title>Liberação</title>
        <link rel="stylesheet" href="css/tabelaresul.css"/>
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
                <button type="button" onclick="window.location.href = 'liberacao.jsp';">Limpar</button>
            </div>
        </form>

        <%
            try {
                // Conectar ao banco de dados
                Connection conecta;
                PreparedStatement st, stAmostra;
                Class.forName("com.mysql.cj.jdbc.Driver");
                conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

                // Base SQL para consulta com filtros
                String sql = "SELECT * FROM relatorio_analises WHERE 1=1 ";

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
                <col style="width: 5%;">
                <col style="width: 5%;">
                <col style="width: 5%;">
                <col style="width: 5%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 1%;">
                <col style="width: 3%;">
                <col style="width: 3%;">
                <col style="width: 3%;">
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
                <th>Responsável</th>
                <th>Situação</th>
                <th>Ações</th>
            </tr>
            <%
                while (rs.next()) {
                    String idAmostra = rs.getString("idamostra");
                    String liberado = rs.getString("liberado");
                    String dataHoraFormatada = rs.getTimestamp("datahoraamostra").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yy HH:mm"));
                    String botaoTexto = "Liberar";
                    String situacao = "Recebida";

                    // Verificar se a amostra está na tabela de amostras
                    stAmostra = conecta.prepareStatement("SELECT * FROM amostras WHERE idamostra = ?");
                    stAmostra.setString(1, idAmostra);
                    ResultSet rsAmostra = stAmostra.executeQuery();
                    if (rsAmostra.next()) {
                        if ("sim".equals(liberado)) {
                            situacao = "Liberado";
                            botaoTexto = "Revisar";
                        } else {
                            situacao = "Em análise";
                        }
                    }

                    // Filtro de situação baseado na lógica existente
                    if (request.getParameter("situacao") != null && !request.getParameter("situacao").isEmpty()
                            && !situacao.equals(request.getParameter("situacao"))) {
                        continue; // Ignorar registros que não correspondem ao filtro
                    }

                    rsAmostra.close();
                    stAmostra.close();
            %>
            <tr>
                <td><%= rs.getInt("idamostra")%></td>
                <td><%= rs.getString("nomeamostra")%></td>
                <td><%= dataHoraFormatada%></td>
                <td><%= rs.getString("cliente")%></td>
                <td><%= String.format("%.2f", rs.getDouble("fe"))%></td>
                <td><%= String.format("%.2f", rs.getDouble("sio2"))%></td>
                <td><%= String.format("%.2f", rs.getDouble("al2o3"))%></td>
                <td><%= String.format("%.3f", rs.getDouble("p"))%></td>
                <td><%= String.format("%.3f", rs.getDouble("mn"))%></td>
                <td><%= String.format("%.2f", rs.getDouble("ppc"))%></td>
                <td><%= String.format("%.2f", rs.getDouble("umidade"))%></td>
                <td><%= rs.getString("responsavelanalise")%></td>
                <td><%= situacao %></td>
                <td>
                    <form action="salvar_liberacao.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="idamostra" value="<%= idAmostra %>">
                        <input type="hidden" name="acao" value="<%= botaoTexto %>">
                        <button type="submit" class="conteudo button"><%= botaoTexto %></button>
                    </form>
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
