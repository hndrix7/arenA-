package br.com.arenaplus.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

import java.time.LocalDate;

public record CampeonatoRequest(
        @NotBlank String nome,
        @NotBlank String modalidade,
        @NotNull LocalDate dataInicio,
        @NotNull LocalDate dataFim,
        @NotNull @Min(2) Integer maxEquipes,
        @Pattern(regexp = "PLANEJADO|EM_ANDAMENTO|ENCERRADO") String status
) {}