testthat::context("test-calculate_energy")

pattern_random_a <- shar::fit_point_process(pattern = shar::species_a,
                                            n_random = 3, verbose = FALSE)

pattern_random_b <- shar::fit_point_process(pattern = shar::species_b,
                                            n_random = 3,
                                            return_input = FALSE, verbose = FALSE)

testthat::test_that("calculate_energy returns energy for all randomizations", {

  testthat::expect_length(shar::calculate_energy(pattern_random_a, verbose = FALSE),
                          n = 3)
})

testthat::test_that("calculate_energy returns mean ", {

  mean_energy <- mean( shar::calculate_energy(pattern_random_a, verbose = FALSE))

  testthat::expect_equal(shar::calculate_energy(pattern_random_a,
                                                return_mean = TRUE,
                                                verbose = FALSE),
                         expected = mean_energy)
})

testthat::test_that("calculate_energy can use comp_fast ", {

  expect_length(shar::calculate_energy(pattern_random_a,
                                       comp_fast = 50,
                                       verbose = FALSE), n = 3)
})

testthat::test_that("calculate_energy returns error if observed not included ", {

  testthat::expect_error(shar::calculate_energy(pattern_random_b, verbose = FALSE),
                         regexp = "Input must named 'randomized_1' to 'randomized_n' and includ 'observed' pattern.")
})
