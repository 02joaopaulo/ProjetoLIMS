<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Timestamp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/usuario.css"/>
        <title>Atualizar Item de Estoque</title>
    </head>
    <body>
        <% 
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                try {
                    // Conectar ao banco de dados
                    Connection conecta;
                    PreparedStatement stSelect, stUpdate, stLog;
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

                    // Capturar a quantidade atual antes da atualização
                    int id = Integer.parseInt(request.getParameter("id"));
                    String nome = request.getParameter("nome");
                    int categoriaId = Integer.parseInt(request.getParameter("categoria_id"));
                    String data = request.getParameter("data");
                    int novaQuantidade = Integer.parseInt(request.getParameter("quantidade"));
                    String usuarioResponsavel = (String) session.getAttribute("usuario"); // Usuário da sessão

                    int quantidadeAnterior = 0;

                    String selectSql = "SELECT quantidade FROM estoque WHERE id = ?";
                    stSelect = conecta.prepareStatement(selectSql);
                    stSelect.setInt(1, id);
                    ResultSet rs = stSelect.executeQuery();
                    if (rs.next()) {
                        quantidadeAnterior = rs.getInt("quantidade");
                    }
                    rs.close();
                    stSelect.close();

                    // Atualizar o item no banco de dados, incluindo a quantidade anterior
                    String updateSql = "UPDATE estoque SET nome = ?, categoria_id = ?, data = ?, quantidade_anterior = ?, quantidade = ?, usuario_responsavel = ? WHERE id = ?";
                    stUpdate = conecta.prepareStatement(updateSql);
                    stUpdate.setString(1, nome);
                    stUpdate.setInt(2, categoriaId);
                    stUpdate.setString(3, data);
                    stUpdate.setInt(4, quantidadeAnterior);
                    stUpdate.setInt(5, novaQuantidade);
                    stUpdate.setString(6, usuarioResponsavel);
                    stUpdate.setInt(7, id);
                    stUpdate.executeUpdate();

                    // Registrar o log
                    String logSql = "INSERT INTO logs (tela, acao, usuario, datahoralog) VALUES (?, ?, ?, ?)";
                    stLog = conecta.prepareStatement(logSql);
                    stLog.setString(1, "estoque");
                    stLog.setString(2, "Atualizado item: " + nome + " | Quantidade anterior: " + quantidadeAnterior + " | Nova quantidade: " + novaQuantidade);
                    stLog.setString(3, usuarioResponsavel);
                    stLog.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
                    stLog.executeUpdate();

                    stLog.close();
                    stUpdate.close();
                    conecta.close();

                    // Redirecionar para a tela de estoque
                    response.sendRedirect("estoque.jsp");
                } catch (Exception e) {
                    out.print("Erro ao atualizar item: " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
        %>
        <div class="form-container">
            <div class="form-box">
                <form method="post" action="atualizar_item.jsp">
                    <input type="hidden" name="id" value="<%= request.getParameter("id") %>">
                    
                    <label for="nome">Nome:</label>
                    <input type="text" id="nome" name="nome" value="<%= request.getParameter("nome") %>" required>

                    <label for="categoria_id">Categoria:</label>
                    <select id="categoria_id" name="categoria_id" required>
                        <% 
                            try {
                                // Conexão para buscar categorias
                                Connection conecta;
                                PreparedStatement st;
                                ResultSet rs;
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");
                                st = conecta.prepareStatement("SELECT idcategoria, nome FROM categorias");
                                rs = st.executeQuery();
                                while (rs.next()) {
                                    int categoriaId = rs.getInt("idcategoria");
                                    String categoriaNome = rs.getString("nome");
                        %>
                        <option value="<%= categoriaId %>" <%= categoriaId == Integer.parseInt(request.getParameter("categoria_id")) ? "selected" : "" %>><%= categoriaNome %></option>
                        <% 
                                }
                                rs.close();
                                st.close();
                                conecta.close();
                            } catch (Exception e) {
                                out.print("Erro ao consultar categorias: " + e.getMessage());
                                e.printStackTrace();
                            }
                        %>
                    </select>

                    <label for="data">Data:</label>
                    <input type="date" id="data" name="data" value="<%= request.getParameter("data") %>" required>

                    <label for="quantidade">Quantidade:</label>
                    <input type="number" id="quantidade" name="quantidade" value="<%= request.getParameter("quantidade") %>" required>

                    <label for="usuario_responsavel">Usuário Responsável:</label>
                    <input type="text" id="usuario_responsavel" name="usuario_responsavel" value="<%= (String) session.getAttribute("usuario") %>" readonly>

                    <button type="submit">Salvar</button>
                </form>
            </div>
        </div>
        <% } %>
    </body>
</html>