package dao;

import connection.ConnectionFactory;
import model.Evento;

import java.sql.*;

public class EventoDAO {

    public void criar(Evento e) {
        String sql = "INSERT INTO evento (titulo, descricao, data_hora, id_local, capacidade, id_categoria, id_organizador, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, e.getTitulo());
            stmt.setString(2, e.getDescricao());
            stmt.setTimestamp(3, Timestamp.valueOf(e.getDataHora()));
            stmt.setInt(4, e.getIdLocal());
            stmt.setInt(5, e.getCapacidade());
            stmt.setInt(6, e.getIdCategoria());
            stmt.setInt(7, e.getIdOrganizador());
            stmt.setString(8, e.getStatus());

            stmt.executeUpdate();
            System.out.println("Evento criado!");

        } catch (SQLException ex) {
            System.out.println("Erro: " + ex.getMessage());
        }
    }
}