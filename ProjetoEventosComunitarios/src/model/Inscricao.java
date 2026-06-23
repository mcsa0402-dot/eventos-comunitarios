package model;

import java.time.LocalDateTime;

public class Inscricao {

    private int id;
    private int idUsuario;
    private int idEvento;
    private LocalDateTime dataInscricao;
    private String status; // CONFIRMADA, PENDENTE, CANCELADA, LISTA_ESPERA

    // GETTER E SETTER - ID
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    // GETTER E SETTER - USUÁRIO
    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    // GETTER E SETTER - EVENTO
    public int getIdEvento() {
        return idEvento;
    }

    public void setIdEvento(int idEvento) {
        this.idEvento = idEvento;
    }

    // GETTER E SETTER - DATA
    public LocalDateTime getDataInscricao() {
        return dataInscricao;
    }

    public void setDataInscricao(LocalDateTime dataInscricao) {
        this.dataInscricao = dataInscricao;
    }

    // GETTER E SETTER - STATUS
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
