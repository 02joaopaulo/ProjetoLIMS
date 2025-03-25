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
        <title>Criar Item</title>
    </head>
    <body>
        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                try {
                    // Conectar ao banco de dados
                    Connection conecta;
                    PreparedStatement st;
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

                    // Inserir novo item no banco de dados
                    String nome = request.getParameter("nome");
                    int categoriaId = Integer.parseInt(request.getParameter("categoria_id"));
                    String data = request.getParameter("data");
                    int quantidade = Integer.parseInt(request.getParameter("quantidade"));
                    String usuarioResponsavel = request.getParameter("usuario_responsavel");

                    st = conecta.prepareStatement("INSERT INTO estoque (nome, categoria_id, data, quantidade, usuario_responsavel) VALUES (?, ?, ?, ?, ?)");
                    st.setString(1, nome);
                    st.setInt(2, categoriaId);
                    st.setString(3, data);
                    st.setInt(4, quantidade);
                    st.setString(5, usuarioResponsavel);
                    st.executeUpdate();

                    // Fechar a conexão
                    st.close();
                    conecta.close();

                    // Redirecionar para a tela de estoque
                    response.sendRedirect("estoque.jsp");
                } catch (Exception e) {
                    out.print("Erro ao criar item: " + e.getMessage());
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
        %>
        <div class="form-container">
            <div class="form-box">
                <form action="criar_item.jsp" method="post">
                    <label for="nome">Nome:</label>
                    <input type="text" id="nome" name="nome" required>
                    <label for="categoria_id">Categoria:</label>
                    <select id="categoria_id" name="categoria_id" required>
                        <%
                            while (rsCategoria.next()) {
                                int categoriaId = rsCategoria.getInt("idcategoria");
                                String categoriaNome = rsCategoria.getString("nome");
                        %>
                        <option value="<%= categoriaId %>"><%= categoriaNome %></option>
                        <%
                            }
                        %>
                    </select>
                    <label for="data">Data:</label>
                    <input type="date" id="data" name="data" required>
                    <label for="quantidade">Quantidade:</label>
                    <input type="number" id="quantidade" name="quantidade" required>
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
                    <button type="submit">Criar</button>
                </form>
            </div>
        </div>
        <%
            }
        %>
    </body>
</html>
