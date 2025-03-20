<%@page import="com.mysql.cj.protocol.Resultset"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Consulta de Usuários</title>
        <link rel="stylesheet" href="css/tabela.css"/>
    </head>
    <body>
        <main>
            <%
                try {
                    // Conectar ao banco de dados
                    Connection conecta;
                    PreparedStatement st, stPerfil;
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

                    // Consultar os dados no banco de dados
                    st = conecta.prepareStatement("SELECT * FROM usuario");
                    ResultSet rs = st.executeQuery();

                    // Consultar perfis disponíveis
                    stPerfil = conecta.prepareStatement("SELECT perfil FROM perfil");
                    ResultSet rsPerfil = stPerfil.executeQuery();
            %>
            <div class="button-container">
                <button onclick="window.location.href = 'criar_usuario.jsp'">Criar Novo Usuário</button>
            </div>
            <table>
                <colgroup>
                    <col style="width: 1%;">
                    <col style="width: 1%;">
                    <col style="width: 1%;">
                    <col style="width: 1%;">
                    <col style="width: 1%;">
                </colgroup>
                <tr>
                    <th>ID Usuário</th>
                    <th>Usuário</th>
                    <th>Senha</th>
                    <th>Perfil</th>
                    <th>Ações</th>
                </tr>
                <%
                    while (rs.next()) {
                        String idUsuario = rs.getString("idusuario");
                        String usuario = rs.getString("usuario");
                        String senha = rs.getString("senha");
                        String perfil = rs.getString("perfil");
                %>
                <tr>
                    <td><%= idUsuario%></td>
                    <td><%= usuario%></td>
                    <td>******</td>
                    <td><%= perfil%></td>
                    <td>
                        <button onclick="window.location.href = 'editar_usuario.jsp?idusuario=<%= idUsuario%>&usuario=<%= usuario%>&senha=<%= senha%>&perfil=<%= perfil%>'">Editar</button>
                        <form action="excluir_usuario.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="idusuario" value="<%= idUsuario%>">
                            <button type="submit">Excluir</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                %>
            </table>
            <%
                    rsPerfil.close();
                    stPerfil.close();
                    rs.close();
                    st.close();
                    conecta.close();
                } catch (Exception e) {
                    out.print("Erro na transmissão para o mySQL: " + e.getMessage());
                    e.printStackTrace();
                }
            %>
        </main>
    </body>
</html>