/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-08-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class DiscountContext {
    private DiscountStrategy strategy;

    // Constructor Injection (Dependency Injection)
    public DiscountContext(DiscountStrategy strategy) {
        this.strategy = strategy;
    }

    public Decimal apply(Decimal amount) {
        return strategy.applyDiscount(amount);
    }
}

// DiscountContext ctx = new DiscountContext(new RegularDiscount());
// System.debug(ctx.apply(1000)); 
