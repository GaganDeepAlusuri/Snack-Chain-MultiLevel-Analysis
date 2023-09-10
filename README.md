# Snack Chain Retail Analysis

![Project Image](https://images.unsplash.com/photo-1578916171728-46686eac8d58?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80)

**Project Description:**
This project focuses on the analysis of transaction data from a snack chain retail business. It explores the effects of pricing and promotion strategies on product sales, unit sales, and customer engagement. The analysis includes data preprocessing, statistical modeling using multi-level models (lmer), and answering key business questions related to product pricing and promotion strategies.

## Table of Contents

- [Introduction](#introduction)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Data Preprocessing](#data-preprocessing)
- [Statistical Modeling](#statistical-modeling)
- [Business Questions](#business-questions)
- [Usage](#usage)

## Introduction

The Snack Chain Retail Analysis project aims to provide valuable insights into the snack chain's sales and pricing strategies. By analyzing transaction data, we uncover the impact of product displays, in-store circulars, and temporary price reductions on product sales, unit sales, and customer engagement. This README provides an overview of the project, its methodologies, and answers to important business questions.

## Getting Started

### Prerequisites

To run this project, you need to have the following software and libraries installed:

- R programming environment
- Required R packages (e.g., `rio`, `dplyr`, `lme4`, `corrplot`, `ggplot2`, etc.)

### Installation

1. Clone this GitHub repository to your local machine.
2. Install R and the required packages mentioned in the project's R script.

## Data Preprocessing

The project starts by importing and preprocessing transaction data, including removing unnecessary columns and handling missing values. Additionally, product categories are refined by excluding "ORAL HYGIENE PRODUCTS."

## Statistical Modeling

Statistical modeling is a crucial part of this project. We utilize multi-level models (lmer) to analyze the effects of various factors on product sales, unit sales, and customer engagement. The modeling includes both fixed and random effects to account for the hierarchical structure of the data.

## Business Questions

The project addresses several business questions, including:

1. What are the effects of product display, being featured on an in-store circular, and temporary price reduction on product sales (spend), unit sales, and the number of household purchasers?
2. How do the effects of display, feature, and TPR on SPEND vary by product categories (cold cereals, frozen pizza, bag snacks) and store segments (mainstream, upscale, value)?
3. What are the five most price elastic and five least price elastic products, based on price elasticity calculations?
4. As the retailer, which products would you lower the price to maximize (a) product sales and (b) unit sales, and why?

## Usage

To use this project, follow the installation instructions and run the R script. You can explore the analysis, findings, and insights related to the snack chain retail business.

