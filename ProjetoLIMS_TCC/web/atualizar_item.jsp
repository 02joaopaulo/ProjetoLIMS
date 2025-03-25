<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/usuario.css"/>
        <title>Atualizar Item</title>
    </head>
    <body>
        <%
            // Inicializar as variáveis para evitar erros
            String data = "";
            String quantidadeAtual = "";
            String usuarioResponsavel = "";

            if ("POST".equalsIgnoreCase(request.getMethod())) {
                try {
                    // Conectar ao banco de dados
                    Connection conecta;
                    PreparedStatement st;
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

                    // Atualizar item no banco de dados
                    int id = Integer.parseInt(request.getParameter("id"));
                    String nome = request.getParameter("nome");
                    int categoriaId = Integer.parseInt(request.getParameter("categoria_id"));
                    data = request.getParameter("data");
                    quantidadeAtual = request.getParameter("quantidade_atual");
                    usuarioResponsavel = request.getParameter("usuario_responsavel");

                    // Consultar a quantidade anterior
                    int quantidadeAnterior = 0;
                    st = conecta.prepareStatement("SELECT quantidade FROM estoque WHERE id = ?");
                    st.setInt(1, id);
                    ResultSet rs = st.executeQuery();
                    if (rs.next()) {
                        quantidadeAnterior = rs.getInt("quantidade");
                    }
                    rs.close();

                    // Atualizar quantidade_anterior e demais campos
                    st = conecta.prepareStatement("UPDATE estoque SET nome = ?, categoria_id = ?, data = ?, quantidade_anterior = ?, quantidade = ?, usuario_responsavel = ? WHERE id = ?");
                    st.setString(1, nome);
                    st.setInt(2, categoriaId);
                    st.setString(3, data);
                    st.setInt(4, quantidadeAnterior);
                    st.setInt(5, Integer.parseInt(quantidadeAtual));
                    st.setString(6, usuarioResponsavel);
                    st.setInt(7, id);
                    st.executeUpdate();

                    // Fechar a conexão
                    st.close();
                    conecta.close();

                    // Redirecionar para a tela de estoque
                    response.sendRedirect("estoque.jsp");
                } catch (Exception e) {
                    out.print("Erro ao atualizar item: " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
                // Consultar categorias e usuários disponíveis
                Connection conecta;
                PreparedStatement stCategoria, stUsuario;
                ResultSet rsCategoria, rsUsuario;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");
                    stCategoria = conecta.prepareStatement("SELECT idcategoria, nome FROM categorias");
                    rsCategoria = stCategoria.executeQuery();
                    
                    stUsuario = conecta.prepareStatement("SELECT usuario FROM usuario WHERE perfil = 'analista'");
                    rsUsuario = stUsuario.executeQuery();

                    // Obter os parâmetros da URL
                    int id = Integer.parseInt(request.getParameter("id"));
                    String nome = request.getParameter("nome");
                    String categoria = request.getParameter("categoria");
                    data = request.getParameter("data");
                    quantidadeAtual = request.getParameter("quantidade_atual");
                    usuarioResponsavel = request.getParameter("usuario_responsavel");
        %>
        <div class="form-container">
            <div class="form-box">
                <form action="atualizar_item.jsp" method="post">
                    <input type="hidden" id="id" name="id" value="<%= id %>">
                    <label for="nome">Nome:</label>
                    <input type="text" id="nome" name="nome" value="<%= nome %>" required>
                    <label for="categoria_id">Categoria:</label>
                    <select id="categoria_id" name="categoria_id" required>
                        <%
                            while (rsCategoria.next()) {
                                int categoriaId = rsCategoria.getInt("idcategoria");
                                String categoriaNome = rsCategoria.getString("nome");
                                String selected = categoriaNome.equals(categoria) ? "selected" : "";
                        %>
                        <option value="<%= categoriaId %>" <%= selected %>><%= categoriaNome %></option>
                        <%
                            }
                        %>
                    </select>
                    <label for="data">Data:</label>
                    <input type="date" id="data" name="data" value="<%= data %>" required>
                    <label for="quantidade_atual">Quantidade Atual:</label>
                    <input type="number" id="quantidade_atual" name="quantidade_atual" value="<%= quantidadeAtual %>" required>
                    <label for="usuario_responsavel">Usuário Responsável:</label>
                    <select id="usuario_responsavel" name="usuario_responsavel" required>
                        <%
                            while (rsUsuario.next()) {
                                String usuario = rsUsuario.getString("usuario");
                        %>
                        <option value="<%= usuario %>"><%= usuario %></option>
                        <%
                            }
                            rsCategoria.close();
                            stCategoria.close();
                            rsUsuario.close();
                            stUsuario.close();
                            conecta.close();
                        } catch (Exception e) {
                            out.print("Erro ao consultar categorias ou usuários: " + e.getMessage());
                            e.printStackTrace();
                        }
                        %>
                    </select>
                    <button type="submit">Atualizar</button>
                </form>
            </div>
        </div>
        <%
            }
        %>
    </body>
</html>
