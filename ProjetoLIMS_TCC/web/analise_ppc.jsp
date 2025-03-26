<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Análise de PPC</title>
    <link rel="stylesheet" href="css/usuario.css"/>
    <script>
        function calcularPPC() {
            const massaCadinho = parseFloat(document.getElementById("massacadinho").value);
            const massaAmostra = parseFloat(document.getElementById("massaamostra").value);
            const massaCalcinada = parseFloat(document.getElementById("massacalcinada").value);

            if (!isNaN(massaCadinho) && !isNaN(massaAmostra) && !isNaN(massaCalcinada)) {
                const ppc = (1 - ((massaCalcinada - massaCadinho) / massaAmostra)) * 100;
                document.getElementById("ppc").textContent = ppc.toFixed(2) + "%";
                document.getElementById("btnSalvar").disabled = false;
            } else {
                alert("Por favor, preencha todos os campos de massa.");
            }
        }
    </script>
</head>
<body>
    <div class="form-container">
        <div class="form-box">
            <form method="post" action="salvar_analise_ppc.jsp">
                <h2>Identificação:</h2>
                <label for="idamostra">ID Amostra:</label>
                <input type="text" name="idamostra" id="idamostra" value="<%= request.getParameter("idamostra") %>" readonly>
                
                <h2>Dados de Entrada:</h2>
                <label for="massacadinho">Massa do Cadinho:</label>
                <input type="number" name="massacadinho" id="massacadinho" step="0.0001" required>
                
                <label for="massaamostra">Massa da Amostra:</label>
                <input type="number" name="massaamostra" id="massaamostra" step="0.0001" required>
                
                <label for="massacalcinada">Massa Calcinada:</label>
                <input type="number" name="massacalcinada" id="massacalcinada" step="0.0001" required>
                
                <button type="button" onclick="calcularPPC()">Calcular</button>
                
                <h2>Resultados:</h2>
                <p>PPC: <span id="ppc">0.00%</span></p>
                
                <h2>Liberação:</h2>
                <label for="responsavelanalise">Responsável pela Análise:</label>
                <select name="responsavelanalise" id="responsavelanalise" required>
                    <%
                        Connection conecta = null;
                        PreparedStatement st = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");
                            st = conecta.prepareStatement("SELECT usuario FROM usuario WHERE perfil = 'analista'");
                            rs = st.executeQuery();
                            while (rs.next()) {
                                String usuario = rs.getString("usuario");
                    %>
                    <option value="<%= usuario %>"><%= usuario %></option>
                    <%
                            }
                        } catch (Exception e) {
                            out.print("Erro ao consultar usuários: " + e.getMessage());
                        } finally {
                            if (rs != null) rs.close();
                            if (st != null) st.close();
                            if (conecta != null) conecta.close();
                        }
                    %>
                </select>
                
                <button type="submit" id="btnSalvar" disabled>Salvar</button>
            </form>
        </div>
    </div>
</body>
</html>
