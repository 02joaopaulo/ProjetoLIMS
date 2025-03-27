<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Excluir Item</title>
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

                    // Excluir item no banco de dados
                    int id = Integer.parseInt(request.getParameter("id"));

                    st = conecta.prepareStatement("DELETE FROM estoque WHERE id = ?");
                    st.setInt(1, id);
                    st.executeUpdate();

                    // Fechar a conexão
                    st.close();
                    conecta.close();

                    // Redirecionar para a tela de estoque
                    response.sendRedirect("estoque.jsp");
                } catch (Exception e) {
                    out.print("Erro ao excluir item: " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
                out.print("Método não suportado.");
            }
        %>
    </body>
</html>

