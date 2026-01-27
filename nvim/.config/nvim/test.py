import time


def sophisticated_calculation(val):
    """
    A helper function to test 'Step Into' (<leader>di)
    and 'Step Out' (<leader>dO).
    """
    result = val * 2
    # Simulate a little work
    time.sleep(0.1)
    return result


def main():
    print("Debug session started...")

    numbers = [10, 20, 30, 40]
    total = 0

    # LOOP: Good for testing 'Continue' (<leader>dc)
    for i, num in enumerate(numbers):
        # VARIABLE: Watch 'current_val' change in the DAP UI (<leader>du)
        current_val = num

        # FUNCTION CALL: Use 'Step Into' (<leader>di) here
        calculated = sophisticated_calculation(current_val)

        total += calculated
        print(f"Step {i + 1}: Input {num} -> Result {calculated}")

    print(f"Final Total: {total}")


if __name__ == "__main__":
    main()
