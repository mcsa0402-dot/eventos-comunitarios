package dao;

import connection.ConnectionFactory;
import model.Usuario;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    // CREATE
    public void criar(Usuario u) {
        String sql = "INSERT INTO usuario (nome, email, senha, cpf, telefone, tipo_usuario) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, u.getNome());
            stmt.setString(2, u.getEmail());
            stmt.setString(3, u.getSenha());
            stmt.setString(4, u.getCpf());
            stmt.setString(5, u.getTelefone());
            stmt.setString(6, u.getTipoUsuario());

            stmt.executeUpdate();
            System.out.println("Usuário criado!");

        } catch (SQLException e) {
            System.out.println("Erro: " + e.getMessage());
        }
    }

    // READ
    public List<Usuario> listar() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuario";

        try (Connection conn = ConnectionFactory.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Usuario u = new Usuario();

                u.setId(rs.getInt("id_usuario"));
                u.setNome(rs.getString("nome"));
                u.setEmail(rs.getString("email"));
                u.setCpf(rs.getString("cpf"));
                u.setTipoUsuario(rs.getString("tipo_usuario"));

                lista.add(u);
            }

        } catch (SQLException e) {
            System.out.println("Erro: " + e.getMessage());
        }

        return lista;
    }

    // UPDATE
    public void atualizar(Usuario u) {
        String sql = "UPDATE usuario SET nome=?, email=? WHERE id_usuario=?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, u.getNome());
            stmt.setString(2, u.getEmail());
            stmt.setInt(3, u.getId());

            stmt.executeUpdate();
            System.out.println("Atualizado!");

        } catch (SQLException e) {
            System.out.println("Erro: " + e.getMessage());
        }
    }

    // DELETE
    public void deletar(int id) {
        String sql = "DELETE FROM usuario WHERE id_usuario=?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();

            System.out.println("Deletado!");

        } catch (SQLException e) {
            System.out.println("Erro: " + e.getMessage());
        }
    }
}