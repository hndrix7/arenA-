package br.com.arenaplus.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "campeonato")
public class Campeonato {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_campeonato")
    private Long idCampeonato;

    @Column(name = "id_organizador", nullable = false)
    private Long idOrganizador;

    @Column(name = "nome", nullable = false, length = 150)
    private String nome;

    @Column(name = "modalidade", nullable = false, length = 80)
    private String modalidade;

    @Column(name = "data_inicio", nullable = false)
    private LocalDate dataInicio;

    @Column(name = "data_fim", nullable = false)
    private LocalDate dataFim;

    @Column(name = "status", nullable = false, length = 20)
    private String status = "PLANEJADO";

    @Column(name = "min_equipes", nullable = false)
    private Integer minEquipes;

    @Column(name = "max_equipes", nullable = false)
    private Integer maxEquipes;

    @Column(name = "pontos_vitoria", nullable = false)
    private Integer pontosVitoria = 3;

    @Column(name = "pontos_empate", nullable = false)
    private Integer pontosEmpate = 1;

    @Column(name = "pontos_derrota", nullable = false)
    private Integer pontosDerrota = 0;

    public Long getIdCampeonato() { return idCampeonato; }
    public void setIdCampeonato(Long idCampeonato) { this.idCampeonato = idCampeonato; }

    public Long getIdOrganizador() { return idOrganizador; }
    public void setIdOrganizador(Long idOrganizador) { this.idOrganizador = idOrganizador; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getModalidade() { return modalidade; }
    public void setModalidade(String modalidade) { this.modalidade = modalidade; }

    public LocalDate getDataInicio() { return dataInicio; }
    public void setDataInicio(LocalDate dataInicio) { this.dataInicio = dataInicio; }

    public LocalDate getDataFim() { return dataFim; }
    public void setDataFim(LocalDate dataFim) { this.dataFim = dataFim; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getMinEquipes() { return minEquipes; }
    public void setMinEquipes(Integer minEquipes) { this.minEquipes = minEquipes; }

    public Integer getMaxEquipes() { return maxEquipes; }
    public void setMaxEquipes(Integer maxEquipes) { this.maxEquipes = maxEquipes; }

    public Integer getPontosVitoria() { return pontosVitoria; }
    public void setPontosVitoria(Integer pontosVitoria) { this.pontosVitoria = pontosVitoria; }

    public Integer getPontosEmpate() { return pontosEmpate; }
    public void setPontosEmpate(Integer pontosEmpate) { this.pontosEmpate = pontosEmpate; }

    public Integer getPontosDerrota() { return pontosDerrota; }
    public void setPontosDerrota(Integer pontosDerrota) { this.pontosDerrota = pontosDerrota; }
}