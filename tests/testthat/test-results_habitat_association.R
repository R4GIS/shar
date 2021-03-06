testthat::context("test-results_habitat_association")

set.seed(42)

random_a <- shar::fit_point_process(pattern = shar::species_a,
                                    n_random = 199,
                                    verbose = FALSE)

landscape_classified <- shar::classify_habitats(raster = shar::landscape,
                                                classes = 5)

raster_random <- shar::randomize_raster(landscape_classified,
                                        n_random = 3,
                                        verbose = FALSE)

result_pattern <- shar::results_habitat_association(raster = landscape_classified,
                                                    pattern = random_a,
                                                    verbose = FALSE)

result_raster <- shar::results_habitat_association(raster = raster_random,
                                                   pattern = shar::species_a,
                                                   verbose = FALSE)

testthat::test_that("results_habitat_association returns one row for each habitat", {

  testthat::expect_equal(nrow(result_pattern), expected = 5)

  testthat::expect_equal(nrow(result_raster), expected = 5)
})

testthat::test_that("results_habitat_association lo is < hi", {

  testthat::expect_true(all(result_pattern$lo < result_pattern$hi))

  testthat::expect_true(all(result_raster$lo < result_raster$hi))
})

testthat::test_that("results_habitat_association returns correct association", {

  result_ns <- dplyr::filter(result_pattern, significance == "n.s.")
  result_pos <- dplyr::filter(result_pattern, significance == "positive")
  result_neg <- dplyr::filter(result_pattern, significance == "negative")

  ns_tf <- result_ns$count >= result_ns$lo & result_ns$count <= result_ns$hi
  pos_tf <- result_pos$count > result_pos$hi
  neg_tf <- result_neg$count < result_neg$lo

  testthat::expect_true(all(c(ns_tf, pos_tf, neg_tf)))
})

testthat::test_that("results_habitat_association returns warning if significance_threshold is not meaningful", {

  testthat::expect_warning(shar::results_habitat_association(raster = landscape_classified,
                                                             pattern = random_a,
                                                             significance_level = 0.75,
                                                             verbose = FALSE))
})

testthat::test_that("results_habitat_association returns error if input is named wrong", {

  testthat::expect_error(shar::results_habitat_association(raster = landscape_classified,
                                                           pattern = unname(random_a),
                                                           verbose = FALSE),
                         regexp = "Input must named 'randomized_1' to 'randomized_n' and includ 'observed' raster.")

  testthat::expect_error(shar::results_habitat_association(raster = raster_random[1:3],
                                                           pattern = shar::species_a,
                                                           verbose = FALSE),
                         regexp = "Input must named 'randomized_1' to 'randomized_n' and includ 'observed' raster.")
})

testthat::test_that("results_habitat_association returns error if wrong input is provided", {

  testthat::expect_error(shar::results_habitat_association(raster = landscape_classified,
                                                           pattern = random_a[[1]],
                                                           verbose = FALSE),
                         regexp = "Please provide either randomized point patterns or randomized rasters.")
})

