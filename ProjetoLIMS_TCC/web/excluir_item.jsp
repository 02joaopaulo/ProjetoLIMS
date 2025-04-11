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
        <title>Excluir Item</title>
    </head>
    <body>
        <% 
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                try {
                    // Conectar ao banco de dados
                    Connection conecta = null;
                    PreparedStatement st = null;
                    PreparedStatement stLog = null;
                    ResultSet rs = null;

                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

                    // Capturar o nome do item antes de excluir
                    String nome = "";
                    int id = Integer.parseInt(request.getParameter("id"));
                    String usuarioResponsavel = (String) session.getAttribute("usuario"); // Usuário da sessão

                    String selectSql = "SELECT nome FROM estoque WHERE id = ?";
                    st = conecta.prepareStatement(selectSql);
                    st.setInt(1, id);
                    rs = st.executeQuery();
                    if (rs.next()) {
                        nome = rs.getString("nome"); // Nome do item capturado
                    }
                    rs.close();
                    st.close();

                    // Excluir item no banco de dados
                    String deleteSql = "DELETE FROM estoque WHERE id = ?";
                    st = conecta.prepareStatement(deleteSql);
                    st.setInt(1, id);
                    int rowsDeleted = st.executeUpdate();

                    // Registrar o log
                    if (rowsDeleted > 0) {
                        String logSql = "INSERT INTO logs (tela, acao, usuario, datahoralog) VALUES (?, ?, ?, ?)";
                        stLog = conecta.prepareStatement(logSql);
                        stLog.setString(1, "estoque");
                        stLog.setString(2, "Excluído item: " + nome);
                        stLog.setString(3, usuarioResponsavel);
                        stLog.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
                        stLog.executeUpdate();
                        stLog.close();
                    }

                    st.close();
                    conecta.close();

                    // Redirecionar para a tela de estoque
                    response.sendRedirect("estoque.jsp");
                } catch (Exception e) {
                    out.print("<p>Erro ao excluir item: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
                    if (st != null) try { st.close(); } catch (Exception e) { e.printStackTrace(); }
                    if (conecta != null) try { conecta.close(); } catch (Exception e) { e.printStackTrace(); }
                }
            } else {
                out.print("<p>Método não suportado.</p>");
            }
        %>
    </body>
</html>