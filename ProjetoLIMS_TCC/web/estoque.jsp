<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Consulta de Estoque</title>
        <link rel="stylesheet" href="css/tabela.css"/>
        <link rel="stylesheet" href="css/filtro.css"/>
    </head>
    <body>
        <div class="button-container">
            <button onclick="window.location.href = 'criar_item.jsp'">Criar Novo Item</button>
        </div>

        <!-- Campos para Filtro -->
        <form method="get" action="" class="filter-container">
            <div class="filter-group">
                <label for="nome">Nome:</label>
                <input type="text" id="nome" name="nome" value="<%= request.getParameter("nome") != null ? request.getParameter("nome") : "" %>">
            </div>
            
            <div class="filter-group">
                <label for="categoria">Categoria:</label>
                <input type="text" id="categoria" name="categoria" value="<%= request.getParameter("categoria") != null ? request.getParameter("categoria") : "" %>">
            </div>
            
            <div class="filter-group">
                <label for="data">Data:</label>
                <input type="date" id="data" name="data" value="<%= request.getParameter("data") != null ? request.getParameter("data") : "" %>">
            </div>
            
            <div class="filter-buttons">
                <button type="submit">Filtrar</button>
                <button type="button" onclick="window.location.href = 'estoque.jsp';">Limpar</button>
            </div>
        </form>

        <table>
            <colgroup>
                <col style="width: 1%;">
                <col style="width: 5%;">
                <col style="width: 5%;">
                <col style="width: 5%;">
                <col style="width: 5%;">
                <col style="width: 5%;">
                <col style="width: 5%;">
                <col style="width: 8%;">
            </colgroup>
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Categoria</th>
                <th>Data</th>
                <th>Quantidade Anterior</th>
                <th>Quantidade Atual</th>
                <th>Usuário Responsável</th>
                <th>Ações</th>
            </tr>
            <%
                try {
                    Connection conecta;
                    PreparedStatement st;
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

                    String sql = "SELECT e.id, e.nome, c.nome AS categoria, e.data, e.quantidade_anterior, e.quantidade AS quantidade_atual, e.usuario_responsavel "
                               + "FROM estoque e JOIN categorias c ON e.categoria_id = c.idcategoria WHERE 1=1 ";

                    if (request.getParameter("nome") != null && !request.getParameter("nome").isEmpty()) {
                        sql += "AND e.nome LIKE ? ";
                    }
                    if (request.getParameter("categoria") != null && !request.getParameter("categoria").isEmpty()) {
                        sql += "AND c.nome LIKE ? ";
                    }
                    if (request.getParameter("data") != null && !request.getParameter("data").isEmpty()) {
                        sql += "AND e.data = ? ";
                    }

                    st = conecta.prepareStatement(sql);

                    int paramIndex = 1;
                    if (request.getParameter("nome") != null && !request.getParameter("nome").isEmpty()) {
                        st.setString(paramIndex++, "%" + request.getParameter("nome") + "%");
                    }
                    if (request.getParameter("categoria") != null && !request.getParameter("categoria").isEmpty()) {
                        st.setString(paramIndex++, "%" + request.getParameter("categoria") + "%");
                    }
                    if (request.getParameter("data") != null && !request.getParameter("data").isEmpty()) {
                        st.setString(paramIndex++, request.getParameter("data"));
                    }

                    ResultSet rs = st.executeQuery();

                    while (rs.next()) {
                        String id = rs.getString("id");
                        String nome = rs.getString("nome");
                        String categoria = rs.getString("categoria");
                        String dataBanco = rs.getString("data");
                        String quantidadeAnterior = rs.getString("quantidade_anterior");
                        String quantidadeAtual = rs.getString("quantidade_atual");
                        String usuarioResponsavel = rs.getString("usuario_responsavel");

                        // Verifica se quantidade_anterior é null
                        if (quantidadeAnterior == null) {
                            quantidadeAnterior = "-";
                        }

                        String dataFormatada = "";
                        if (dataBanco != null) {
                            SimpleDateFormat formatoBanco = new SimpleDateFormat("yyyy-MM-dd");
                            SimpleDateFormat formatoDesejado = new SimpleDateFormat("dd/MM/yy");
                            Date data = formatoBanco.parse(dataBanco);
                            dataFormatada = formatoDesejado.format(data);
                        }
            %>
            <tr>
                <td><%= id %></td>
                <td><%= nome %></td>
                <td><%= categoria %></td>
                <td><%= dataFormatada %></td>
                <td><%= quantidadeAnterior %></td>
                <td><%= quantidadeAtual %></td>
                <td><%= usuarioResponsavel %></td>
                <td>
                    <button onclick="window.location.href = 'atualizar_item.jsp?id=<%= id %>&nome=<%= nome %>&categoria=<%= categoria %>&data=<%= dataBanco %>&quantidade_anterior=<%= quantidadeAnterior %>&quantidade_atual=<%= quantidadeAtual %>&usuario_responsavel=<%= usuarioResponsavel %>'">Atualizar</button>
                    <form action="excluir_item.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= id %>">
                        <button type="submit">Excluir</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                    rs.close();
                    st.close();
                    conecta.close();
                } catch (Exception e) {
                    out.print("Erro na transmissão para o MySQL: " + e.getMessage());
                    e.printStackTrace();
                }
            %>
        </table>
    </body>
</html>